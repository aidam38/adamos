#!/bin/python

# load input files
aliases = open('/home/adam/scripts/aliases', 'r')
lfrc_in = open('/home/adam/.config/lf/lfrc', 'r')
bashrc_in = open('/home/adam/.bashrc', 'r')

lfrc = ''
bashrc = ''

# read input files
for l in lfrc_in.readlines():
    if (l == '# directories aliases\n'):
        lfrc += l
        break
    else:
        lfrc += l

for l in bashrc_in.readlines():
    if (l == '# directories aliases\n'):
        bashrc += l
        break
    else:
        bashrc += l

# append aliases
for a in aliases.readlines():
    if(len(a.split()) < 3):
        lfrc += 'map b' + a.split()[0] + ' cd ' + a.split()[1] + '\n'
        bashrc += 'alias b' + a.split()[0] + \
            '=\'cd ' + a.split()[1] + '\'' + '\n'
    else:
        lfrc += 'map b' + a.split()[0] + ' cd ' + a.split()[1] + '\n'
        lfrc += 'map C' + \
            a.split()[0] + ' :cd ' + a.split()[1] + \
            '; $$EDITOR ' + a.split()[2] + '\n'
        bashrc += 'alias b' + a.split()[0] + \
            '=\'cd ' + a.split()[1] + '\'' + '\n'
        bashrc += 'alias C' + \
            a.split()[0] + '=\'cd ' + a.split()[1] + \
            ' && ' + '$EDITOR ' + a.split()[2] + '\'' + '\n'

print(lfrc)
print(bashrc)

lfrc_out = open('/home/adam/.config/lf/lfrc', 'w')
bashrc_out = open('/home/adam/.bashrc', 'w')

lfrc_out.write(lfrc)
bashrc_out.write(bashrc)
