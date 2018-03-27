import sys, random, time, datetime, json
from cassandra.cluster import Cluster

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
    cluster = Cluster(['node1', 'node2', 'node3'])
    session = cluster.connect()
    try:
        session.execute("CREATE KEYSPACE bsk WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 3 }")
        session.execute("CREATE TABLE bsk.app (time timestamp PRIMARY KEY,src varchar,dst varchar,title varchar,value varchar)")
    except Exception as e:
        print(' '.join(['Olewam ciepłym moczem, że:',str(e)]))

    while True:
        row          = {}
        row['src']   = genAccount() 
        row['dst']   = genAccount()
        row['title'] = random.choice(title)
        row['value'] = str(float("{0:.2f}".format(random.uniform(10, 100))))
        print(row)


        session.execute(
            session.prepare("INSERT INTO bsk.app (time,src,dst,title,value) VALUES (dateof(now()),?,?,?,?)"),
            (row['src'],row['dst'],row['title'],row['value'])
            #(str(row['src']),'','','')
        )
        time.sleep(random.randint(0, 10))
    cluster.shutdown()
        
        
if (__name__ == '__main__'):
    try:
        populate()
    except(KeyboardInterrupt):
        sys.exit(0)
