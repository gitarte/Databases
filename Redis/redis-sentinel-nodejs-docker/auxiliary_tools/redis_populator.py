import sys, random, time, datetime, json
from redis.sentinel import Sentinel

title = (
    u'Za waciki',
    u'Za przejście przewz ucho igielne',
    u'Za halba na hołdzie',
    u'Lepiej nie pytać',
    u'Lepiej nie wiedzieć',
    u'Na dobrą zmianę',
    u'Na Solidarność',
    u'Na Ojca Dyrektora',
    u'Cygarety, piwo, dziewczynki',
    u'Wieczór kawalerski u Łysego',
    u'Za wypożyczenie borskuka',
    u'Za strzyżenie owcy',
    u'Łapówki zaległe',
    u'Niespodzianka: Losowy tytuł przelewu 1',
    u'Niespodzianka: Losowy tytuł przelewu 2',
    u'Niespodzianka: Losowy tytuł przelewu 3',
    u'Niespodzianka: Losowy tytuł przelewu 4',
    u'Niespodzianka: Losowy tytuł przelewu 5',
    u'Na błogosławionych ubogich w duchu',
    u'Tylko nie rozpuść na głupoty', 
    u'Na utrzymanie syna marnotrawnego',
    u'Dla syjonistycznej hydry nienasyconej',
    u'Na feministki, bo zarabiają mniej niż mężczyźni',
    u'1, 2, 3 - próba przelewu',
    u'Za jamnik, klarnet i kiszkę wieprzową',
    u'Za mało',
    u'Za siedmioma górami',
    u'Za miatanie',
    u'Alimenty chwalipięty',
    u'A udław się!'
)

def genAccount():
    cc = random.randint(10, 99)
    aa = random.randint(10000000, 99999999)
    bb = random.randint(1000000000000000, 9999999999999999)
    return "".join([str(cc), str(aa), str(bb)])
    
    
def populate():
    sentinel = Sentinel([
        ('node1.localdomain', 26379),
        ('node2.localdomain', 26379),
        ('node3.localdomain', 26379)
    ],
        socket_timeout = 0.1,
        password = 'stupidpassword3'
    )

    while True:
        time.sleep(random.randint(0, 10))
        jsonRow = ''
        row = {}
        
        row['time']  = str(datetime.datetime.utcnow()),
        row['src']   = genAccount(), 
        row['dst']   = genAccount(),
        row['title'] = random.choice(title),
        row['value'] = float("{0:.2f}".format(random.uniform(10, 100)))

        jsonRow = json.dumps(row)
        
        sentinel.discover_master('myRedisMaster')
        sentinel.discover_slaves('myRedisMaster')
        master = sentinel.master_for('myRedisMaster', socket_timeout=0.1)
        slave  = sentinel.slave_for('myRedisMaster', socket_timeout=0.1)
        master.rpush('bsk_state', jsonRow)
        print(jsonRow)
        
        
        
        #actualState = slave.lrange('bsk_state', -10, -1)
        #for v in actualState:
        #    print(v)
        
        
if (__name__ == '__main__'):
    try:
        populate()
    except(KeyboardInterrupt):
        sys.exit(0)
