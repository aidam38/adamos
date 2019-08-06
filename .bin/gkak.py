#!/usr/bin/python3
import abc
import sys
import json

import gi
gi.require_version("Gdk", "3.0")
gi.require_version("Gtk", "3.0")
gi.require_version("cairo", "1.0")
gi.require_version("Pango", "1.0")
gi.require_version("PangoCairo", "1.0")

from gi.repository import GLib, Gio, Gdk, Pango, PangoCairo, Gtk

import cairo

DEFAULT_COLOR = (-1, -1, -1)

NAMED_COLORS = {
    "default":        DEFAULT_COLOR,
    "black":          (0.000, 0.000, 0.000),
    "red":            (0.800, 0.000, 0.000),
    "green":          (0.306, 0.604, 0.024),
    "yellow":         (0.769, 0.627, 0.000),
    "blue":           (0.204, 0.396, 0.643),
    "magenta":        (0.459, 0.314, 0.482),
    "cyan":           (0.024, 0.596, 0.604),
    "white":          (0.827, 0.843, 0.812),
    "bright-black":   (0.333, 0.341, 0.325),
    "bright-red":     (0.937, 0.161, 0.161),
    "bright-green":   (0.541, 0.886, 0.204),
    "bright-yellow":  (0.988, 0.914, 0.310),
    "bright-blue":    (0.447, 0.624, 0.812),
    "bright-magenta": (0.678, 0.498, 0.659),
    "bright-cyan":    (0.204, 0.886, 0.886),
    "bright-white":   (0.933, 0.933, 0.925),
}

KAKOUNE_NAMED_KEYS = {
    Gdk.KEY_Return: "ret",
    Gdk.KEY_KP_Enter: "ret",
    Gdk.KEY_space: "space",
    Gdk.KEY_Tab: "tab",
    Gdk.KEY_ISO_Left_Tab: "tab",
    Gdk.KEY_BackSpace: "backspace",
    Gdk.KEY_Delete: "del",
    Gdk.KEY_Escape: "esc",
    Gdk.KEY_Up: "up",
    Gdk.KEY_Down: "down",
    Gdk.KEY_Left: "left",
    Gdk.KEY_Right: "right",
    Gdk.KEY_Page_Up: "pageup",
    Gdk.KEY_Page_Down: "pagedown",
    Gdk.KEY_Home: "home",
    Gdk.KEY_End: "end",
    Gdk.KEY_F1: "f1",
    Gdk.KEY_F2: "f2",
    Gdk.KEY_F3: "f3",
    Gdk.KEY_F4: "f4",
    Gdk.KEY_F5: "f5",
    Gdk.KEY_F6: "f6",
    Gdk.KEY_F7: "f7",
    Gdk.KEY_F8: "f8",
    Gdk.KEY_F9: "f9",
    Gdk.KEY_F10: "f10",
    Gdk.KEY_F11: "f11",
    Gdk.KEY_F12: "f12",
}

def color_to_css(r, g, b):
    return f"rgb({r*100}%, {g*100}%, {b*100}%)".encode("UTF-8")

class JsonRpcServer:

    def __init__(self, cmdline, callbacks):

        self.callbacks = callbacks

        self.subprocess = Gio.Subprocess.new(
            cmdline,
            Gio.SubprocessFlags.STDIN_PIPE
            | Gio.SubprocessFlags.STDOUT_PIPE,
        )
        self.from_child = self.subprocess.get_stdout_pipe()
        self.to_child = self.subprocess.get_stdin_pipe()

        self.cancel_flag = Gio.Cancellable.new()

        self.single_receive_buffer = bytes(4096)
        self.total_receive_buffer = bytes()
        self._start_receive_bytes()

        self.subprocess.wait_async(self.cancel_flag, self._process_quit)

    def _start_receive_bytes(self):
        self.from_child.read_async(
            self.single_receive_buffer,
            GLib.PRIORITY_DEFAULT,
            self.cancel_flag,
            self._finish_receive_bytes,
        )

    def _finish_receive_bytes(self, source, result):
        try:
            byte_count = source.read_finish(result)
        except GLib.Error as e:
            if e.matches(Gio.io_error_quark(), Gio.IOErrorEnum.CANCELLED):
                # It's OK, we asked for this.
                return
            else:
                # this is not the error we were expecting.
                self.close()
                raise

        # Add this new data to the data we already received
        self.total_receive_buffer += \
            memoryview(self.single_receive_buffer)[:byte_count]

        eol = self.total_receive_buffer.find(b"\n")
        while eol != -1:
            try:
                data = json.loads(self.total_receive_buffer[:eol])
            except json.JSONDecodeError as e:
                print("Received broken JSON from child:", e.msg)
                print(e.doc)
                print(" " * (e.pos - 2), "^")
                self.subprocess.force_exit()
                return
            except UnicodeDecodeError as e:
                print("Received broken JSON from child:", e)
                print(repr(self.total_receive_buffer[:eol]))
                self.subprocess.force_exit()
                return

            self.callbacks.json_received(data)
            self.total_receive_buffer = self.total_receive_buffer[eol+1:]

            eol = self.total_receive_buffer.find(b"\n")

        # Queue another read
        self._start_receive_bytes()

    def _process_quit(self, source, result):
        source.wait_finish(result)

        # Stop waiting for any new data from the process, it's not coming.
        self.cancel_flag.cancel()

        # Tell somebody that the process has quit.
        self.callbacks.json_quit()

    def json_send(self, method, *args):
        data = {
            "jsonrpc": "2.0",
            "method": method,
            "params": args,
        }
        buf = bytes(json.dumps(data), "utf-8")
        self.to_child.write(buf, None)

    def close(self):
        if self.cancel_flag.is_cancelled():
            # We're already in the middle of closing.
            return

        # Kill the process.
        self.subprocess.force_exit()

class Face:

    def __init__(self, fg, bg, attributes):
        # FIXME: handle reverse attribute
        self.fg = fg
        self.bg = bg
        self.attributes = set(attributes)

    @classmethod
    def from_json_face(cls, data):
        def parse_color(text):
            if text.startswith("#") and len(text) == 7:
                return (
                    int(text[1:3], 16) / 255,
                    int(text[3:5], 16) / 255,
                    int(text[5:7], 16) / 255,
                )

            if text in NAMED_COLORS:
                return NAMED_COLORS[text]

            print("Unrecognised color:", repr(text))
            return DEFAULT_COLOR

        fg = parse_color(data["fg"])
        bg = parse_color(data["bg"])
        attributes = set(data["attributes"])

        return cls(fg, bg, attributes)

    def effective_fg(self):
        return NAMED_COLORS["white"] if self.fg == DEFAULT_COLOR else self.fg

    def effective_bg(self):
        return NAMED_COLORS["black"] if self.bg == DEFAULT_COLOR else self.bg

    @classmethod
    def default(cls):
        return cls(DEFAULT_COLOR, DEFAULT_COLOR, set())

    def set_source_to_fg(self, cairo_context):
        cairo_context.set_source_rgb(*self.effective_fg())

    def set_source_to_bg(self, cairo_context):
        cairo_context.set_source_rgb(*self.effective_bg())

    def to_css(self):
        res = b"* {"

        if self.fg != DEFAULT_COLOR:
            res += b"color:"
            res += color_to_css(*self.effective_fg())
            res += b";"
        if self.bg != DEFAULT_COLOR:
            res += b"background:"
            res += color_to_css(*self.effective_bg())
            res += b";"

        if "underline" in self.attributes:
            res += b"text-decoration: underline;"
        if "bold" in self.attributes:
            res += b"font-weight: bold;"
        if "dim" in self.attributes:
            res += b"opacity: 0.5;"
        if "italic" in self.attributes:
            res += b"font-style: italic;"
        if "blink" in self.attributes:
            # FIXME: support blink?
            print("Unsupported text attribute 'blink'")

        res += b"}"
        print(f"Built CSS: {res!r}")
        return res

    def merge_face(self, other):
        if "exclusive" in other.attributes:
            return other

        fg = self.fg if other.fg == DEFAULT_COLOR else other.fg
        bg = self.bg if other.bg == DEFAULT_COLOR else other.bg
        attributes = self.attributes | other.attributes

        return self.__class__(fg, bg, attributes)

    def merge_atom(self, atom):
        return Atom(
            self.merge_face(atom.face),
            atom.contents,
        )

class Atom:

    def __init__(self, face, contents):
        self.face = face
        self.contents = contents

    @classmethod
    def from_json_atom(cls, data):
        return cls(
            Face.from_json_face(data["face"]),
            data["contents"].replace("\n", " ")
        )

    def width_ch(self):
        # FIXME: use wcswidth instead
        return len(self.contents)

    def draw(self, cr, layout, x_px, y_px, w_px, h_px):
        # Draw the background behind the text
        cr.rectangle(x_px, y_px, w_px, h_px)
        self.face.set_source_to_bg(cr)
        cr.fill()

        # Figure out the standard character width
        context = layout.get_context()
        font = context.load_font(layout.get_font_description())
        metrics = font.get_metrics(None)
        char_w_px = (
            metrics.get_approximate_char_width()
        ) / Pango.SCALE

        text = self.contents

        # In a proportional font, spaces are probably much less than char_w_px,
        # while visible characters are probably much wider. Thus, if we let
        # Pango layout an Atom with leading or trailing whitespace, the text
        # will wind up much wider than it should be. Therefore, we strip
        # leading and trailing whitespace from the text, and adjust x_px and
        # w_px to match.
        l_stripped_text = text.lstrip()
        stripped_chars = len(text) - len(l_stripped_text)
        if stripped_chars:
            text = l_stripped_text
            x_px += stripped_chars * char_w_px
            w_px -= stripped_chars * char_w_px

        r_stripped_text = text.rstrip()
        stripped_chars = len(text) - len(r_stripped_text)
        if stripped_chars:
            text = r_stripped_text
            w_px -= stripped_chars * char_w_px

        text = text.replace("&", "&amp;")
        text = text.replace("<", "&lt;")
        text = text.replace(">", "&gt;")
        if "underline" in self.face.attributes:
            text = f"<u>{text}</u>"
        if "bold" in self.face.attributes:
            text = f"<b>{text}</b>"
        if "dim" in self.face.attributes:
            text = f"<span alpha='50%'>{text}</span>"
        if "italic" in self.face.attributes:
            text = f"<i>{text}</i>"
        if "blink" in self.face.attributes:
            # FIXME: support blink?
            print("Unsupported text attribute 'blink'")
        layout.set_markup(text, -1)

        # Measure the size of the text we need to draw.
        PangoCairo.update_layout(cr, layout)
        text_w_px, text_h_px = layout.get_pixel_size()
        if text_w_px == 0 or text_h_px == 0:
            # No text to actually draw
            return

        cr.save()
        cr.move_to(x_px, y_px)
        self.face.set_source_to_fg(cr)

        # Configure Cairo to scale the text to the space we have available
        cr.set_matrix(cairo.Matrix(xx=(w_px/text_w_px), yy=(h_px/text_h_px)))

        # Actually draw the text.
        PangoCairo.show_layout(cr, layout)
        cr.restore()

class CompletionMenu(Gtk.Window):

    def __init__(self, parent):
        super().__init__(Gtk.WindowType.POPUP)
        self.set_transient_for(parent)

        self.items = []
        self.menu_face = Face.default()
        self.selected_face = Face.default()
        self.selected_index = 0
        self.font_desc = None

        self.scroller = Gtk.ScrolledWindow.new()
        self.scroller.set_policy(
            Gtk.PolicyType.NEVER,
            Gtk.PolicyType.AUTOMATIC,
        )
        self.add(self.scroller)

        self.canvas = Gtk.DrawingArea()
        self.canvas.connect("draw", self.on_draw)
        self.scroller.add(self.canvas)

        self.canvas.add_events(
            Gdk.EventMask.BUTTON_PRESS_MASK
            | Gdk.EventMask.BUTTON1_MOTION_MASK
            | Gdk.EventMask.BUTTON_RELEASE_MASK
        )
        self.canvas.connect("button-press-event", self.on_mouse_down, parent)
        self.canvas.connect("motion-notify-event", self.on_mouse_move, parent)
        self.canvas.connect("button-release-event", self.on_mouse_up, parent)

        self.mouse_pressed = False

    def _select_item_at_offset(self, y_px, widget, parent):
        allocation = widget.get_allocation()
        parent.menu_item_selected(
            int(y_px / allocation.height * len(self.items))
        )

    def on_draw(self, source, cr):
        layout = source.create_pango_layout()
        layout.set_font_description(self.font_desc)

        allocation = source.get_allocation()
        canvas_w_px = allocation.width
        canvas_h_px = allocation.height

        # Paint the default background everywhere
        cr.rectangle(0, 0, canvas_w_px, canvas_h_px)
        self.menu_face.set_source_to_bg(cr)
        cr.fill()

        # Paint all the menu items
        for y_ch, line in enumerate(self.items):
            x_ch = 0
            for atom in line:
                if y_ch == self.selected_index:
                    atom = self.selected_face.merge_atom(atom)
                else:
                    atom = self.menu_face.merge_atom(atom)

                atom.draw(
                    cr,
                    layout,
                    x_ch * self.char_w_px,
                    y_ch * self.char_h_px,
                    atom.width_ch() * self.char_w_px,
                    self.char_h_px,
                )

                x_ch += atom.width_ch()

            if y_ch == self.selected_index:
                # The atoms on this line of the menu do not necessarily extend
                # to the right-hand border, so if this line is selected we'll
                # have to fill the space to the end of the line ourselves.
                cr.rectangle(
                    x_ch * self.char_w_px,
                    y_ch * self.char_h_px,
                    canvas_w_px - x_ch * self.char_w_px,
                    self.char_h_px,
                )
                self.selected_face.set_source_to_bg(cr)
                cr.fill()

    def on_mouse_down(self, source, event, parent):
        if event.button != 1:
            return

        self.mouse_pressed = True
        self._select_item_at_offset(event.y, source, parent)

    def on_mouse_move(self, source, event, parent):
        if not self.mouse_pressed:
            return

        self._select_item_at_offset(event.y, source, parent)

    def on_mouse_up(self, source, event, parent):
        if event.button != 1:
            return

        if not self.mouse_pressed:
            return

        self.mouse_pressed = False

        self._select_item_at_offset(event.y, source, parent)

    def set_content(self, anchor_win_px, items, menu_face, selected_face):
        self.items = items
        self.menu_face = menu_face
        self.selected_face = selected_face

        self.set_selection(None)

        menu_desired_height_px = len(items) * self.char_h_px
        menu_desired_width_px = max(
            sum(atom.width_ch() for atom in line)
            for line in items
        ) * self.char_w_px

        self.canvas.set_size_request(
            menu_desired_width_px,
            menu_desired_height_px,
        )

        self.resize(
            menu_desired_width_px,
            min(menu_desired_height_px, 10 * self.char_h_px),
        )

        if self.font_desc and self.items:
            self.show_all()

        self.get_window().move_to_rect(
            anchor_win_px,
            Gdk.Gravity.SOUTH_WEST,
            Gdk.Gravity.NORTH_WEST,
            (
                Gdk.AnchorHints.FLIP
                | Gdk.AnchorHints.SLIDE_X
                | Gdk.AnchorHints.RESIZE_Y
            ),
            0,
            0,
        )

        self.canvas.queue_draw()

    def set_selection(self, index):
        if index == len(self.items):
            self.selected_index = None
        else:
            self.selected_index = index

        adjustment = self.scroller.get_vadjustment()

        if self.selected_index is None:
            # Nothing selected, scroll to the top.
            adjustment.set_value(adjustment.get_lower())
        else:
            # Keep the selected item in view.
            adjustment.clamp_page(
                self.selected_index * self.char_h_px,
                (self.selected_index + 1) * self.char_h_px,
            )

        self.scroller.set_vadjustment(adjustment)

        self.canvas.queue_draw()

    def set_font(self, font_desc):
        self.font_desc = font_desc

        context = self.get_pango_context()
        font = context.load_font(font_desc)
        metrics = font.get_metrics(None)
        self.char_w_px = (
            metrics.get_approximate_char_width()
        ) / Pango.SCALE
        self.char_h_px = (
            metrics.get_ascent() + metrics.get_descent()
        ) / Pango.SCALE


class FontSettings:

    def __init__(self, callback):
        # pick a default font
        schema_name = "org.gnome.desktop.interface"
        key_name = "monospace-font-name"

        # Uncomment this if just getting the setting directly breaks when
        # GNOME is not fully installed.
        #schema_source = Gio.SettingsSchemaSource.get_default()
        #schema = schema_source.lookup(schema_name, recursive=True)
        #if schema is not None and key_name in schema.list_keys():
        self.settings = Gio.Settings.new(schema_name)
        self.settings.connect("changed::" + key_name, self._set_default_font)

        self.default = self.settings.get_string(key_name)

        #else:
        #    self.default = "Monospace 10"

        self.override = None
        self.callback = callback

    def _set_default_font(self, settings, key_name):
        self.default = settings.get_string(key_name)
        self._fire_callback()

    def override_font(self, font_name):
        self.override = font_name
        self._fire_callback()

    def _fire_callback(self):
        self.callback(
            self.override
            if self.override
            else self.default
        )

class KakouneWindow(Gtk.Window):

    def __init__(self, args):
        super().__init__()

        self.body_lines = []
        self.background_face = Face.default()
        self.padding_atom = Atom(Face.default(), "~")
        self.status_line = []
        self.mode_line = []
        self.info_panel = None
        self.menu_child = CompletionMenu(self)
        self.cursor_x_ch = 0
        self.cursor_y_ch = 0
        self.width_ch = 80
        self.height_ch = 25
        self.mouse_pressed = False

        self.overlay = Gtk.Overlay()
        self.add(self.overlay)

        self.darea = Gtk.DrawingArea()
        self.darea.connect("draw", self.on_draw)
        self.darea.connect("button-press-event", self.on_mouse_down)
        self.darea.connect("motion-notify-event", self.on_mouse_move)
        self.darea.connect("button-release-event", self.on_mouse_up)
        self.darea.connect("scroll-event", self.on_mouse_scroll)
        self.darea.add_events(
            Gdk.EventMask.POINTER_MOTION_MASK
            | Gdk.EventMask.BUTTON_PRESS_MASK
            | Gdk.EventMask.BUTTON_RELEASE_MASK
            | Gdk.EventMask.SCROLL_MASK
        )
        self.overlay.add(self.darea)

        self.set_title("Kakoune GTK")
        self.connect("delete-event", self.on_delete)
        self.connect("configure-event", self.on_configure)
        self.connect("key-press-event", self.on_key_press)

        self.font_settings = FontSettings(self._set_font)
        self.font_settings.override_font(None)

        self.kakoune = JsonRpcServer(
            ["kak", "-ui", "json"] + args,
            self,
        )

    def _set_font(self, font_name):
        font_desc = Pango.font_description_from_string(font_name)
        self.layout = Pango.Layout.new(self.darea.get_pango_context())
        self.layout.set_font_description(font_desc)
        self.menu_child.set_font(font_desc)

        # Figure out what actual font we'll be using to render text.
        context = self.layout.get_context()
        font = context.load_font(font_desc)
        metrics = font.get_metrics(None)
        self.char_w_px = (
            metrics.get_approximate_char_width()
        ) / Pango.SCALE
        self.char_h_px = (
            metrics.get_ascent() + metrics.get_descent()
        ) / Pango.SCALE

        self.resize(
            self.width_ch * self.char_w_px,
            self.height_ch * self.char_h_px,
        )

    def on_delete(self, widget, event):
        self.font_settings = None
        self.menu_child.close()
        self.menu_child = None
        self.kakoune.close()
        self.kakoune = None
        Gtk.main_quit()
        return False

    def on_configure(self, source, event):
        # The event includes a width and height, but they include space for
        # client-side decorations that we don't care about.
        real_width, real_height = self.get_size()
        self.width_ch = int(real_width / self.char_w_px)
        self.height_ch = int(real_height / self.char_h_px)

        # Leave a line for the status/mode line.
        self.kakoune.json_send("resize", self.height_ch - 1, self.width_ch)

        # Things we can only do once the window is visible.
        self.get_window().set_cursor(
            Gdk.Cursor.new_from_name(self.get_display(), "text"),
        )

        return False

    def on_key_press(self, source, event):
        # On keypress, turn off the mouse-cursor since it gets in the way.
        self.get_window().set_cursor(
            Gdk.Cursor.new_from_name(self.get_display(), "none"),
        )

        ctrl = event.state & Gdk.ModifierType.CONTROL_MASK
        alt = event.state & Gdk.ModifierType.MOD1_MASK
        shift = event.state & Gdk.ModifierType.SHIFT_MASK

        if event.keyval in KAKOUNE_NAMED_KEYS:
            keystr = KAKOUNE_NAMED_KEYS[event.keyval]

            if keystr == "space" and shift:
                # Kakoune doesn't like <s-space> for some reason.
                shift = False

        # FIXME: Instead of event.string, use GtkIMContext for proper Compose
        # support.
        elif event.string:
            if event.string == "<":
                keystr = "lt"
            elif event.string == ">":
                keystr = "gt"
            elif event.string == "-":
                keystr = "minus"
            else:
                keystr = event.string

            # Kakoune is built for the terminal, and doesn't like the
            # shift-modifier being used on text characters.
            shift = False

            if "\x00" <= event.string <= "\x1F":
                # In the C0 control range.
                keystr = chr(ord(event.string) + 64).lower()
                ctrl = True

        else:
            print("Ignoring unrecognised key", Gdk.keyval_name(event.keyval))
            return

        if shift: keystr = "s-" + keystr
        if alt: keystr = "a-" + keystr
        if ctrl: keystr = "c-" + keystr

        keystr = "<" + keystr + ">"

        #print("Sending key:", keystr)

        self.kakoune.json_send("keys", keystr)
        return False

    def _send_mouse_event(self, name, x_px, y_px):
        x_ch = int(x_px / self.char_w_px)
        y_ch = int(y_px / self.char_h_px)

        # Clamp horizontal coordinate to our window size
        x_ch = max(0, min(x_ch, self.width_ch))

        if name == "move" and y_ch < 0:
            # Off the top of the window, let's scroll up instead.
            name = "wheel_up"
            y_ch = 0

        elif name == "move" and y_ch > self.height_ch:
            # Off the bottom of the window, let's scroll down instead.
            name = "wheel_down"
            y_ch = self.height_ch

        else:
            # Clamp vertical coordinate to our window size
            y_ch = max(0, min(y_ch, self.height_ch))

        self.kakoune.json_send("mouse", name, y_ch, x_ch)

    def on_mouse_down(self, widget, event):
        if event.button != 1:
            return False

        self.mouse_pressed = True

        self._send_mouse_event("press", event.x, event.y)

    def on_mouse_move(self, widget, event):
        # On pointer movement, turn the cursor back on so we can see it.
        self.get_window().set_cursor(
            Gdk.Cursor.new_from_name(self.get_display(), "text"),
        )

        if not self.mouse_pressed:
            return False

        self._send_mouse_event("move", event.x, event.y)

    def on_mouse_up(self, widget, event):
        if event.button != 1:
            return False

        if not self.mouse_pressed:
            return False

        self._send_mouse_event("release", event.x, event.y)

    def on_mouse_scroll(self, widget, event):
        name = {
            Gdk.ScrollDirection.UP: "wheel_up",
            Gdk.ScrollDirection.DOWN: "wheel_down",
        }.get(event.direction)

        if name is None:
            return False

        self._send_mouse_event(name, event.x, event.y)

    def on_draw(self, wid, cr):
        width_px, height_px = self.get_size()

        # Paint the default background everywhere
        cr.rectangle(0, 0, width_px, height_px)
        self.background_face.set_source_to_bg(cr)
        cr.fill()

        # Draw the lines we've been given
        y_ch = 0
        for y_ch, line in enumerate(self.body_lines):
            x_ch = 0

            for atom in line:
                atom.draw(
                    cr,
                    self.layout,
                    x_ch * self.char_w_px,
                    y_ch * self.char_h_px,
                    atom.width_ch() * self.char_w_px,
                    self.char_h_px,
                )

                x_ch += atom.width_ch()

        # Fill the rest of the screen up to the modeline with padding.
        for y_ch in range(y_ch + 1, self.height_ch - 1):
            self.padding_atom.draw(
                cr,
                self.layout,
                0,
                y_ch * self.char_h_px,
                self.char_w_px,
                self.char_h_px,
            )
            y_ch += 1

        # Draw the mode line right-justified at the bottom.
        mode_line_width_ch = sum(
            atom.width_ch()
            for atom in self.mode_line
        )
        x_ch = self.width_ch - mode_line_width_ch
        y_ch = self.height_ch - 1
        for atom in self.mode_line:
            atom.draw(
                    cr,
                    self.layout,
                    x_ch * self.char_w_px,
                    y_ch * self.char_h_px,
                    atom.width_ch() * self.char_w_px,
                    self.char_h_px,
                )

            x_ch += atom.width_ch()

        # If the mode is too wide, fade out the left-most character.
        if self.width_ch < mode_line_width_ch:
            gradient = cairo.LinearGradient(0, 0, self.char_w_px, 0)
            gradient.add_color_stop_rgba(0.0, *self.background_face.bg, 1.0)
            gradient.add_color_stop_rgba(1.0, *self.background_face.bg, 0.0)
            cr.rectangle(
                0,
                (self.height_ch - 1) * self.char_h_px,
                self.char_w_px,
                self.char_h_px,
            )
            cr.set_source(gradient)
            cr.fill()

        # Draw the status-line left-justified at the bottom, if there is one.
        if self.status_line:
            x_ch = 0
            y_ch = self.height_ch - 1
            for atom in self.status_line:
                atom.draw(
                        cr,
                        self.layout,
                        x_ch * self.char_w_px,
                        y_ch * self.char_h_px,
                        atom.width_ch() * self.char_w_px,
                        self.char_h_px,
                    )
                x_ch += atom.width_ch()

            remainder_x_ch = x_ch
            remainder_y_ch = self.height_ch - 1
            remainder_w_ch = self.width_ch - x_ch
            remainder_h_ch = 1

            # In case the status-line is overlapping the mode-line,
            # fade out the mode-line.
            gradient = cairo.LinearGradient(
                remainder_x_ch * self.char_w_px,
                0,
                width_px,
                0,
            )
            gradient.add_color_stop_rgba(0.0, *self.background_face.bg, 1.0)
            gradient.add_color_stop_rgba(1.0, *self.background_face.bg, 0.0)
            cr.rectangle(
                remainder_x_ch * self.char_w_px,
                remainder_y_ch * self.char_h_px,
                remainder_w_ch * self.char_w_px,
                remainder_h_ch * self.char_h_px,
            )
            cr.set_source(gradient)
            cr.fill()

    def json_received(self, data):
        handler = getattr(self, "kakoune_" + data["method"])
        handler(*data["params"])

    def json_quit(self):
        self.close()

    def kakoune_draw(self, lines, default_face, padding_face):
        self.background_face = Face.from_json_face(default_face)
        self.body_lines = [
            [
                self.background_face.merge_atom(Atom.from_json_atom(atom))
                for atom in line
            ]
            for line in lines
        ]

        self.padding_atom = self.background_face.merge_atom(
            Atom.from_json_atom({
                "face": padding_face,
                "contents": "~",
            })
        )

    def kakoune_draw_status(self, status_line, mode_line, default_face):
        status_default_face = Face.default().merge_face(
            Face.from_json_face(default_face)
        )

        self.status_line = [
            status_default_face.merge_atom(Atom.from_json_atom(atom))
            for atom in status_line
        ]
        self.mode_line = [
            status_default_face.merge_atom(Atom.from_json_atom(atom))
            for atom in mode_line
        ]

        mode_line_text = ""
        for each in self.mode_line:
            mode_line_text += each.contents

        if mode_line_text:
            mode_line_text += " - Kakoune GTK"
        else:
            mode_line_text = "Kakoune GTK"

        self.set_title(mode_line_text)

    def kakoune_menu_show(self, items, anchor, selected_face, menu_face, style):
        menu_items = [
            [Atom.from_json_atom(each) for each in line]
            for line in items
        ]
        menu_selected_face = Face.from_json_face(selected_face)
        menu_face = Face.from_json_face(menu_face)

        if style in ("prompt", "search"):
            self.anchor_x_ch = self.cursor_x_ch
            self.anchor_y_ch = self.cursor_y_ch
        else:
            self.anchor_x_ch = anchor["column"]
            self.anchor_y_ch = anchor["line"]

        # Where is the menu anchor in relation to the window?
        anchor_win_px = Gdk.Rectangle()
        anchor_win_px.x, anchor_win_px.y = self.darea.translate_coordinates(
            self,
            self.anchor_x_ch * self.char_w_px,
            self.anchor_y_ch * self.char_h_px,
        )
        anchor_win_px.width = self.char_w_px
        anchor_win_px.height = self.char_h_px

        self.menu_child.set_content(
            anchor_win_px,
            menu_items,
            menu_face,
            menu_selected_face,
        )

    def kakoune_menu_select(self, index):
        self.menu_child.set_selection(index)

    def kakoune_menu_hide(self):
        self.menu_child.hide()

    def kakoune_info_show(self, title, content, anchor, face, style):
        if self.info_panel:
            # Apparently there's no nice way to remove a widget from a
            # Gtk.Overlay
            self.info_panel.destroy()
            self.info_panel = None

        style_provider = Gtk.CssProvider()
        style_provider.load_from_data(Face.from_json_face(face).to_css())

        if style == "prompt":
            self.info_panel = Gtk.VBox()

            label = Gtk.Label()
            label.set_text(title.rstrip("\n"))
            label.set_property("margin", self.char_w_px)
            label.set_property("margin-bottom", 0)
            label.set_xalign(0.5)
            self.info_panel.add(label)

            body = Gtk.Label()
            body.set_text(content.rstrip("\n"))
            body.set_line_wrap(True)
            body.set_property("margin", self.char_w_px)
            self.info_panel.add(body)

            self.info_panel.set_halign(Gtk.Align.END)
            self.info_panel.set_valign(Gtk.Align.END)
            # TODO: Make the margin bigger if the window height is not an even
            # multiple of the character height.
            self.info_panel.set_property("margin-bottom", self.char_h_px)

            style_context = self.info_panel.get_style_context()
            style_context.add_provider(
                style_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION,
            )

            self.overlay.add_overlay(self.info_panel)

        else:
            print("Unhandled info style:", style)

    def kakoune_info_hide(self):
        if self.info_panel:
            # Apparently there's no nice way to remove a widget from a
            # Gtk.Overlay
            self.info_panel.destroy()
            self.info_panel = None

    def kakoune_set_cursor(self, mode, coord):
        self.cursor_x_ch = coord["column"]

        if mode == "prompt":
            self.cursor_y_ch = self.height_ch - 1
        else:
            self.cursor_y_ch = coord["line"]

    def kakoune_set_ui_options(self, options):
        if "gtk_font" in options:
            self.font_settings.override_font(options["gtk_font"])
        else:
            self.font_settings.override_font(None)

    def kakoune_refresh(self, force):
        self.show_all()
        self.queue_draw()

    def menu_item_selected(self, index):
        self.kakoune.json_send("menu_select", index)

def main():

    app = KakouneWindow(sys.argv[1:])
    Gtk.main()

if __name__ == "__main__":
    main()
