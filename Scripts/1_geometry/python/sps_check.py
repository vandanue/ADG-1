fname1 = 'Line_001.SPS'
fname2 = 'Line_001.RPS'
fname3 = 'Line_001.XPS'

fhand = open(fname1)
sp=[]
for line in fhand:
    line = line.strip()
    if not line.startswith('H26'):
        list = sp.append(line[17:25])
sp.sort()

fhand = open(fname2)
rp = []
for line in fhand:
    if not line.startswith('H26'):
        line = line.strip()
        rp.append(line[17:25])
rp.sort()

fhand = open(fname3)
xps = []
rcv_shot = []

for line in fhand:
    if not line.startswith('H26'):
        line = line.strip()
        xps.append(line[7:11])
        rcv_shot.append(int(line[42:46])-int(line[38:42])+1)
xps.sort()

print('============= SPS FILE=============')
print('First Shot Point: ',sp[0])
print('Last Shot Point: ',sp[-1])
print('Total number of shots: ', len(sp), 'VPs')
print('============= RPS FILE=============')
print('First Receiver Point: ',rp[0])
print('Last Shot Point: ',rp[-1])
print('Total number of receivers: ', len(rp), 'Receiver')
print('============= XPS FILE=============')
print('First Field File ID: ',xps[0])
print('Last Field File ID: ',xps[-1])
print('Total number of traces: ',sum(rcv_shot))

fhand = open(fname1)
sp=[]
for line in fhand:
    if not line.startswith('H26'):
        line = line.strip()
        print(line[17:25],line[28:32])
        
