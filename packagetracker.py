# Design
# https://www.figma.com/file/yujRqicTWiesdDWbXPZSrI/Untitled?type=design&node-id=0-1&mode=design

from flask import Flask, request, jsonify  # pip install asasdasd
import sqlite3 # pip install sqlite3
import os
from flask import jsonify  # pip install flask
import requests    # pip install requests
import json
import polyline # pip install polyline
from datetime import datetime, timedelta

app = Flask(__name__)
basedir = os.path.abspath(os.path.dirname(__file__))

# database 
databasename = '_database.db'
admins_table = 'admins_table'
emplyees_table = 'emplyees_table'
customers_table = 'customers_table'
vehicles_table = 'vehicles_table'
tasks_table = 'tasks_table'

try: # create database and tables if not exist
  print(f'Checking if {databasename} exists or not...')
  conn = sqlite3.connect(databasename, uri=True)
  print(f'Database exists. Succesfully connected to {databasename}')
  conn.execute('CREATE TABLE IF NOT EXISTS ' + admins_table + ' (id INTEGER PRIMARY KEY AUTOINCREMENT,email TEXT UNIQUE NOT NULL,password TEXT NOT NULL, nationalnumber TEXT,birthday TEXT,phone TEXT,firstname TEXT,lastname TEXT,username TEXT UNIQUE NOT NULL)')
  conn.execute('CREATE TABLE IF NOT EXISTS ' + emplyees_table + ' (id INTEGER PRIMARY KEY AUTOINCREMENT,email TEXT UNIQUE NOT NULL,password TEXT NOT NULL, nationalnumber TEXT,birthday TEXT,phone TEXT,firstname TEXT,lastname TEXT,username TEXT UNIQUE NOT NULL)')
  conn.execute('CREATE TABLE IF NOT EXISTS ' + customers_table + ' (id INTEGER PRIMARY KEY AUTOINCREMENT,email TEXT UNIQUE NOT NULL,password TEXT NOT NULL, nationalnumber TEXT,birthday TEXT,phone TEXT,firstname TEXT,lastname TEXT,username TEXT UNIQUE NOT NULL)')
  conn.execute('CREATE TABLE IF NOT EXISTS ' + vehicles_table + ' (id INTEGER PRIMARY KEY AUTOINCREMENT,vehicleID TEXT UNIQUE NOT NULL,manufacturer TEXT,modelyear INTEGER,color TEXT,size TEXT,trackerID, lat TEXT , lng TEXT ,distance TEXT)')
  conn.execute('CREATE TABLE IF NOT EXISTS ' + tasks_table + ' (id INTEGER PRIMARY KEY AUTOINCREMENT,tasknumber TEXT,employeeid TEXT ,vehicleid TEXT, deadline TEXT,loadlocation TEXT, unloadlocation TEXT,taskdescription TEXT, approved boolean default False, finished boolean default False,customerid TEXT, loaddate TEXT, started boolean default False,sensordistance INTEGER default 10000, unloadlatbysensor TEXT , unloadlngbysensor TEXT, unloadlatbyuser TEXT , unloadlngbyuser TEXT, finishedbysensor boolean default False,status TEXT default "",approveddate TEXT default "",starteddate TEXT default "",loadeddate TEXT default "",unloadeddate TEXT default "",finisheddate TEXT default "", unloaddate TEXT)')
#   id ,tasknumber ,employeeid ,vehicleid , deadline ,loadlocation , unloadlocation ,taskdescription , approved 
  print(f'Succesfully Created Tables')
except sqlite3.OperationalError as err:
  print('Database error,see log')
  print(err)

# create admin if none exist
connt = sqlite3.connect(databasename, uri=True)
curt = connt.cursor()
conn = sqlite3.connect(databasename, uri=True)
cur = conn.cursor()
curt.execute('select * from '+ admins_table )
records = curt.fetchall()
if len(records)==0:
    sqlite_insert_query = 'INSERT INTO '+ admins_table +' (email,password,username) VALUES (?,?,?);'
    data_tuple = ("noor@a.a","1234","noor")
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()

# create employee if none exist
curt.execute('select * from '+ emplyees_table )
records = curt.fetchall()
if len(records)==0:
    sqlite_insert_query = 'INSERT INTO '+ emplyees_table +' (email,password,nationalnumber,username) VALUES (?,?,?,?);'
    data_tuple = ("mona@a.a","1234","1111111111","mona",)
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()
    sqlite_insert_query = 'INSERT INTO '+ emplyees_table +' (email,password,nationalnumber,username) VALUES (?,?,?,?);'
    data_tuple = ("noha@a.a","1234","2222222222","noha",)
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()

curt.execute('select * from '+ customers_table )
records = curt.fetchall()
if len(records)==0:
    sqlite_insert_query = 'INSERT INTO '+ customers_table +' (email,password,nationalnumber,username) VALUES (?,?,?,?);'
    data_tuple = ("ahmed@a.a","1234","3333333333","ahmed",)
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()
    sqlite_insert_query = 'INSERT INTO '+ customers_table +' (email,password,nationalnumber,username) VALUES (?,?,?,?);'
    data_tuple = ("tolba@a.a","1234","4444444444","tolba",)
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()

# create vehicle if none exist
curt.execute('select * from '+ vehicles_table )
records = curt.fetchall()
if len(records)==0:
    sqlite_insert_query = 'INSERT INTO '+ vehicles_table +' (vehicleID,manufacturer,modelyear ,color ,size,trackerid) VALUES (?,?,?,?,?,?);'
    data_tuple = ("k1234","turkey","2020","red","truck","tracker0123",)
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()
    sqlite_insert_query = 'INSERT INTO '+ vehicles_table +' (vehicleID,manufacturer,modelyear ,color ,size) VALUES (?,?,?,?,?);'
    data_tuple = ("c4567","jaban","2020","red","motorcycle",)
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()

#   id ,tasknumber ,employeeid ,vehicleid , deadline ,loadlocation , unloadlocation ,taskdescription , approved 

curt.execute('select * from '+ tasks_table )
records = curt.fetchall()
if len(records)==0:
    sqlite_insert_query = 'INSERT INTO '+ tasks_table +' (tasknumber ,employeeid ,vehicleid , deadline ,loadlocation , unloadlocation ,taskdescription , customerid,unloadlatbyuser,unloadlngbyuser,status) VALUES (?,?,?,?,?,?,?,?,?,?,?);'
    data_tuple = ("t11","1111111111","k1234","2010","Mekkah Saudi Arabia","Jeddah Saudi Arabia","test task created automatically for test purposes","3333333333","21.490696138945257", "39.20285181944909","not approved")
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()
    sqlite_insert_query = 'INSERT INTO '+ tasks_table +' (tasknumber ,employeeid ,vehicleid , deadline ,loadlocation , unloadlocation ,taskdescription   ,customerid,unloadlatbyuser,unloadlngbyuser,status) VALUES (?,?,?,?,?,?,?,?,?,?,?);'
    data_tuple = ("t22","2222222222","k1234","2010","Mekkah Saudi Arabi","Al Jumum Saudi Arabia","test task created automatically for test purposes","4444444444","21.61240913668553", "39.69892366351948","not approved")
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()
    sqlite_insert_query = 'INSERT INTO '+ tasks_table +' (tasknumber ,employeeid ,vehicleid , deadline ,loadlocation , unloadlocation ,taskdescription  ,customerid,unloadlatbyuser,unloadlngbyuser,status) VALUES (?,?,?,?,?,?,?,?,?,?,?);'
    data_tuple = ("t33","2222222222","k1234","2010","Mekkah Saudi Arabi","Al Qirw Saudi Arabia","test task created automatically for test purposes","4444444444","21.168777890843945", "39.59882133277183","not approved")    
    cur.execute(sqlite_insert_query,data_tuple)
    conn.commit()


connt.close()    
conn.close()


@app.route('/', methods=['GET'])
def home():
    return "Server is running"

@app.route('/login', methods=['POST'])
def login():
    print("login")
    success=False
    username = "null"
    email = ""
    userid = ""
    usertype = ""
    
    if request.method == 'POST':
        print("post")
        # print(request.args)
        username = request.args.get('username')  #request.json['username']
        password = request.args.get('password')
        con = sqlite3.connect(databasename, uri=True)
        cur2 = con.cursor()
        cur2.execute('select * from '+ admins_table +' where username = ? and password = ? ', (username,password,))
        records = cur2.fetchall()
        if len(records)>0:
            success=True
            username = username
            usertype = "admin"
            email = records[0][1]
        else:
            cur2.execute('select * from '+ emplyees_table +' where username = ? and password = ? ', (username,password,))
            records = cur2.fetchall()
            if len(records)>0:
                success=True
                username = username
                usertype = "employee"
                userid = records[0][3] 
                email = records[0][1]
            else:
                cur2.execute('select * from '+ customers_table +' where username = ? and password = ? ', (username,password,))
                records = cur2.fetchall()
                if len(records)>0:
                    success=True
                    username = username
                    usertype = "customer"
                    userid = records[0][3]
                    mail = records[0][1]

        cur2.close()
        con.close()

    resp = jsonify(success=success,username = username, userid=userid,usertype=usertype,email = email)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/addemployee', methods=['POST'])
def addemployee():
    print("addemployee")
    success = False
    message = ""
    status = 0 
    if request.method == 'POST':
        print("post") 
        if not "firstname" in request.args:
            message = "Invalid firstname"
            status = -10 
        if not "lastname" in request.args:
            message = "Invalid lastname"
            status = -11 
        if not "birthday" in request.args:
            message = "Invalid birthday"
            status = -12 
        if not "phone" in request.args:
            message = "Invalid phone"
            status = -13 
        if not "email" in request.args:
            message = "Invalid email"
            status = -14 
        if not "nationalnumber" in request.args:
            message = "Invalid national number"
            status = -15 
        if not "username" in request.args:
            message = "Invalid username"
            status = -16 
        if not "password" in request.args:
            message = "Invalid password"
            status = -17 


        if status == 0: # all inputs are valid
            firstname = request.args.get('firstname')
            lastname = request.args.get('lastname')
            birthday = request.args.get('birthday')
            phone = request.args.get('phone')
            email = request.args.get('email')
            nationalnumber = request.args.get('nationalnumber')
            username = request.args.get('username')
            password = request.args.get('password')
            if firstname == "" or len(firstname) < 3: 
                message = "Invalid firstname" 
                status = -20
            if lastname == "" or len(lastname) < 3:
                message = "Invalid lastname"
                status = -21 
            if  birthday == "" or len(birthday) < 3:
                message = "Invalid birthday"
                status = -22 
            if  len(phone) != 10 or not phone.isdigit():
                message = "Invalid phone"
                status = -23 
            else:
                if phone[0] != "0":
                    message = "Invalid phone"
                    status = -23 
            if  email == "" or len(email) < 3 or email.find('@')<0 or email.find('.')<0 :
                message = "Invalid email"
                status = -24 
            # print(len(nationalnumber))
            # print(nationalnumber[0] != 1 and nationalnumber[0] != 2)
            # print(nationalnumber.isdigit())
            if  len(nationalnumber) != 10 or (nationalnumber[0] != "1" and nationalnumber[0] != "2") or not nationalnumber.isdigit():
                message = "Invalid national number"
                status = -25 
            if  username == "" or len(username) < 3:
                message = "Invalid username"
                status = -26 
            if  password == "" or len(password) < 3:
                message = "Invalid password"
                status = -27 
            if status == 0:
                con = sqlite3.connect(databasename, uri=True)
                cur2 = con.cursor()
                cur2.execute('select * from '+ emplyees_table +' where email = ? or username = ? or nationalnumber = ? or phone = ? ', (email,username,nationalnumber,phone,))
                records = cur2.fetchall()
                if len(records) > 0: # one paramiter unduplicable already exists 
                    message = "Duplicated entery"
                    status = -1
                    # id ,email ,password , nationalnumber ,birthday ,phone ,firstname ,lastname ,username 
                    for row in records:
                        # print(row)
                        if row[1] == email:
                            message = "Duplicated Email"
                            status = -2
                        if row[8] == username:
                            message = "Duplicated username"
                            status = -3
                        if row[3] == nationalnumber:
                            message = "Duplicated national number"
                            status = -4
                        if row[5] == phone:
                            message = "Duplicated phone"
                            status = -5
                        break
                else: # store employee
                    cur2.execute('INSERT INTO ' + emplyees_table + ' (firstname,lastname,birthday,phone,email,nationalnumber,username,password) VALUES (?,?,?,?,?,?,?,?) ', (firstname,lastname,birthday,phone,email,nationalnumber,username,password,))
                    con.commit()
                    success = True
                    status = 1
                cur2.close()
                con.close()        
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp


@app.route('/addcustomer', methods=['POST'])
def addcustomer():
    print("addcustomer")
    success = False
    message = ""
    status = 0 
    if request.method == 'POST':
        print("post") 
        if not "firstname" in request.args:
            message = "Invalid firstname"
            status = -10 
        if not "lastname" in request.args:
            message = "Invalid lastname"
            status = -11 
        if not "birthday" in request.args:
            message = "Invalid birthday"
            status = -12 
        if not "phone" in request.args:
            message = "Invalid phone"
            status = -13 
        if not "email" in request.args:
            message = "Invalid email"
            status = -14 
        if not "nationalnumber" in request.args:
            message = "Invalid national number"
            status = -15 
        if not "username" in request.args:
            message = "Invalid username"
            status = -16 
        if not "password" in request.args:
            message = "Invalid password"
            status = -17 


        if status == 0: # all inputs are valid
            firstname = request.args.get('firstname')
            lastname = request.args.get('lastname')
            birthday = request.args.get('birthday')
            phone = request.args.get('phone')
            email = request.args.get('email')
            nationalnumber = request.args.get('nationalnumber')
            username = request.args.get('username')
            password = request.args.get('password')
            if firstname == "" or len(firstname) < 3: 
                message = "Invalid firstname" 
                status = -20
            if lastname == "" or len(lastname) < 3:
                message = "Invalid lastname"
                status = -21 
            if  birthday == "" or len(birthday) < 3:
                message = "Invalid birthday"
                status = -22 
            if  len(phone) != 10 or not phone.isdigit():
                message = "Invalid phone"
                status = -23 
            else:
                if phone[0] != "0":
                    message = "Invalid phone"
                    status = -23
            if  email == "" or len(email) < 3 or email.find('@')<0 or email.find('.')<0 :
                message = "Invalid email"
                status = -24 
            if  len(nationalnumber) != 10 or not nationalnumber.isdigit():
                message = "Invalid national number"
                status = -25 
            else:
                if nationalnumber[0] != "1" and nationalnumber[0] != "2":
                    message = "Invalid national number"
                    status = -25 
            if  username == "" or len(username) < 3:
                message = "Invalid username"
                status = -26 
            if  password == "" or len(password) < 3:
                message = "Invalid password"
                status = -27 
            if status == 0:
                con = sqlite3.connect(databasename, uri=True)
                cur2 = con.cursor()
                # id,email ,password , nationalnumber ,birthday ,phone ,firstname ,lastname ,username
                cur2.execute('select * from '+ customers_table +' where email = ? or username = ? or nationalnumber = ? or phone = ? ', (email,username,nationalnumber,phone,))
                records = cur2.fetchall()
                if len(records) > 0: # one paramiter unduplicable already exists 
                    message = "Duplicated entery"
                    status = -1
                    # id ,email ,password , nationalnumber ,birthday ,phone ,firstname ,lastname ,username 
                    for row in records:
                        # print(row)
                        if row[1] == email:
                            message = "Duplicated Email"
                            status = -2
                        if row[8] == username:
                            message = "Duplicated username"
                            status = -3
                        if row[3] == nationalnumber:
                            message = "Duplicated national number"
                            status = -4
                        if row[5] == phone:
                            message = "Duplicated phone"
                            status = -5
                        break
                else: # store employee
                    cur2.execute('INSERT INTO ' + customers_table + ' (firstname,lastname,birthday,phone,email,nationalnumber,username,password) VALUES (?,?,?,?,?,?,?,?) ', (firstname,lastname,birthday,phone,email,nationalnumber,username,password,))
                    con.commit()
                    success = True
                    status = 1
                cur2.close()
                con.close()        
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp


@app.route('/addvehicle', methods=['POST'])
def addvehicle():
    print("addvehicle")
    success = False
    message = ""
    status = 0 
    # vehicleID=$vehicleID&manufacturer=$manufacturer&modelyear=$modelyear&color=$color&sizee=$sizee
    if request.method == 'POST':
        print("post") 
        if not "vehicleID" in request.args:
            message = "Invalid vehicleID"
            status = -10 
        if not "manufacturer" in request.args:
            message = "Invalid manufacturer"
            status = -11 
        if not "modelyear" in request.args:
            message = "Invalid modelyear"
            status = -12 
        if not "color" in request.args:
            message = "Invalid color"
            status = -13 
        if not "sizee" in request.args:
            message = "Invalid sizee"
            status = -14 
        if not "trackerid" in request.args:
            message = "Invalid tracker id"
            status = -15 

        if status == 0: # all inputs are valid
            vehicleID = request.args.get('vehicleID')
            manufacturer = request.args.get('manufacturer')
            modelyear = request.args.get('modelyear')
            color = request.args.get('color')
            sizee = request.args.get('sizee')
            trackerid = request.args.get('trackerid')
            if vehicleID == "" or len(vehicleID) < 3: 
                message = "Invalid vehicleID" 
                status = -20
            if manufacturer == "" or len(manufacturer) < 3:
                message = "Invalid manufacturer"
                status = -21 
            if  modelyear == "" or len(modelyear) < 3:
                message = "Invalid modelyear"
                status = -22 
            if  color == "" or len(color) < 3:
                message = "Invalid color"
                status = -23 
            if  sizee == "" or len(sizee) < 3:
                message = "Invalid size"
                status = -24 
            if  trackerid == "":
                message = "Invalid tracker id"
                status = -25 

            if status == 0:
                con = sqlite3.connect(databasename, uri=True)
                cur2 = con.cursor()
                cur2.execute('select * from '+ vehicles_table +' where vehicleID = ? ', (vehicleID,))
                records = cur2.fetchall()
                if len(records) > 0: # one paramiter unduplicable already exists 
                    message = "Duplicated entery"
                    status = -1
                    # id ,vehicleID ,manufacturer ,modelyear ,color ,size  
                    for row in records:
                        # print(row)
                        if row[1] == vehicleID:
                            message = "Duplicated vehicle ID"
                            status = -2                        
                        break
                else: # store employee
                    cur2.execute('INSERT INTO ' + vehicles_table + ' (vehicleID ,manufacturer ,modelyear ,color ,size,trackerid) VALUES (?,?,?,?,?,?) ', (vehicleID ,manufacturer ,modelyear ,color ,sizee,trackerid,))
                    con.commit()
                    message = "Vehicle Added successfully"
                    success = True
                    status = 1
                cur2.close()
                con.close()        
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/addtask', methods=['POST'])
def addtask():
    print("addtask")
    success = False
    message = ""
    status = 0 

    if request.method == 'POST':
        print("post") 
        if not "tasknumber" in request.args:
            message = "Invalid task number"
            status = -10 
        if not "employeeID" in request.args:
            message = "Invalid employee ID"
            status = -11 
        if not "VehicleID" in request.args:
            message = "Invalid Vehicle ID"
            status = -12 
        if not "deadline" in request.args:
            message = "Invalid deadline"
            status = -13 
        if not "loadlocation" in request.args:
            message = "Invalid load location"
            status = -14 
        if not "unloadlocation" in request.args:
            message = "Invalid unload location"
            status = -15 
        if not "taskdescription" in request.args:
            message = "Invalid task description"
            status = -16
            

        if status == 0: # all inputs are valid
            tasknumber = request.args.get('tasknumber')
            employeeID = request.args.get('employeeID')
            VehicleID = request.args.get('VehicleID')
            deadline = request.args.get('deadline')
            loadlocation = request.args.get('loadlocation')
            unloadlocation = request.args.get('unloadlocation')
            taskdescription = request.args.get('taskdescription')
            if tasknumber == "" or len(tasknumber) < 3: 
                message = "Invalid task number" 
                status = -20
            if employeeID == "" or len(employeeID) < 3:
                message = "Invalid employee ID"
                status = -21 
            if  VehicleID == "" or len(VehicleID) < 3:
                message = "Invalid Vehicle ID"
                status = -22 
            if  deadline == "" or len(deadline) < 3:
                message = "Invalid deadline"
                status = -23 
            if  loadlocation == "" or len(loadlocation) < 3:
                message = "Invalid loadlocation"
                status = -24 
            if  unloadlocation == "" or len(unloadlocation) < 3:
                message = "Invalid unloadlocation"
                status = -25 
            if  taskdescription == "" or len(taskdescription) < 3:
                message = "Invalid taskdescription"
                status = -26


            if status == 0:
                key = "AIzaSyAjdw0zgEfP606e0tm1dJ3uXrYCP7-dzxo"
                api_response = requests.get('https://maps.googleapis.com/maps/api/geocode/json?address={0}&key={1}'.format(unloadlocation, key))
                api_response_dict = api_response.json()

                if api_response_dict['status'] == 'OK':
                    unloadlatbyuser = api_response_dict['results'][0]['geometry']['location']['lat']
                    unloadlngbyuser = api_response_dict['results'][0]['geometry']['location']['lng']
                else:
                    unloadlatbyuser = ""
                    unloadlngbyuser = ""
                
                con = sqlite3.connect(databasename, uri=True)
                cur2 = con.cursor()
                cur2.execute('select * from '+ tasks_table +' where tasknumber = ? order by loaddate DESC', (tasknumber,))
                records = cur2.fetchall()
                if len(records) > 0: # one paramiter unduplicable already exists 
                    message = "Duplicated entery"
                    status = -1
                    # id ,vehicleID ,manufacturer ,modelyear ,color ,size  
                    for row in records:
                        # print(row)
                        if row[1] == tasknumber:
                            message = "Task number already used"
                            status = -2                        
                        break
                else: # store employee
                    cur2.execute('INSERT INTO ' + tasks_table + ' (tasknumber ,employeeid ,vehicleid ,deadline ,loadlocation,unloadlocation,taskdescription,unloadlatbyuser,unloadlngbyuser) VALUES (?,?,?,?,?,?,?,?,?) ', (tasknumber ,employeeID ,VehicleID ,deadline ,loadlocation,unloadlocation,taskdescription,unloadlatbyuser,unloadlngbyuser,))
                    con.commit()
                    message = "Task Added successfully"
                    success = True
                    status = 1
                cur2.close()
                con.close()        
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/addtaskbycustomer', methods=['POST'])
def addtaskbycustomer():
    print("addtaskbycustomer")
    success = False
    message = ""
    status = 0 

    if request.method == 'POST':
        print("post") 
        if not "loaddate" in request.args:
            message = "Invalid loaddate"
            status = -12 
        if not "unloaddate" in request.args:
            message = "Invalid unloaddate"
            status = -122 
        if not "deadline" in request.args:
            message = "Invalid deadline"
            status = -13 
        if not "loadlocation" in request.args:
            message = "Invalid load location"
            status = -14 
        if not "unloadlocation" in request.args:
            message = "Invalid unload location"
            status = -15 
        if not "taskdescription" in request.args:
            message = "Invalid task description"
            status = -16
            

        if status == 0: # all inputs are valid
            loaddate = request.args.get('loaddate')
            unloaddate = request.args.get('unloaddate')
            deadline = request.args.get('deadline')
            loadlocation = request.args.get('loadlocation')
            unloadlocation = request.args.get('unloadlocation')
            taskdescription = request.args.get('taskdescription')
            customerid = request.args.get('customerid')
            if  loaddate == "" or len(loaddate) < 3:
                message = "Invalid loaddate"
                status = -23 
            if  unloaddate == "" or len(unloaddate) < 3:
                message = "Invalid unloaddate"
                status = -233 
            if  deadline == "" or len(deadline) < 3:
                message = "Invalid deadline"
                status = -23 
            if  loadlocation == "" or len(loadlocation) < 3:
                message = "Invalid loadlocation"
                status = -24 
            if  unloadlocation == "" or len(unloadlocation) < 3:
                message = "Invalid unloadlocation"
                status = -25 
            if  taskdescription == "" or len(taskdescription) < 3:
                message = "Invalid taskdescription"
                status = -26

            if status == 0:
                key = "AIzaSyAjdw0zgEfP606e0tm1dJ3uXrYCP7-dzxo"
                api_response = requests.get('https://maps.googleapis.com/maps/api/geocode/json?address={0}&key={1}'.format(unloadlocation, key))
                api_response_dict = api_response.json()

                if api_response_dict['status'] == 'OK':
                    unloadlatbyuser = api_response_dict['results'][0]['geometry']['location']['lat']
                    unloadlngbyuser = api_response_dict['results'][0]['geometry']['location']['lng']
                else:
                    unloadlatbyuser = ""
                    unloadlngbyuser = ""

                con = sqlite3.connect(databasename, uri=True)
                cur2 = con.cursor()                
                cur2.execute('INSERT INTO ' + tasks_table + ' (loaddate,unloaddate,  deadline ,loadlocation,unloadlocation,taskdescription,unloadlatbyuser,unloadlngbyuser,customerid,status) VALUES (?,?,?,?,?,?,?,?,?,?) ', (loaddate ,unloaddate ,deadline ,loadlocation,unloadlocation ,taskdescription,unloadlatbyuser,unloadlngbyuser,customerid,"not approved"))
                con.commit()
                # lastid = cur2.lastrowid
                cur2.execute('UPDATE ' + tasks_table + ' SET tasknumber = ? WHERE id = ? ', (cur2.lastrowid ,cur2.lastrowid,))
                con.commit()
                message = "Task Added successfully"
                success = True
                status = 1


                cur2.close()
                con.close()        
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/listemployees', methods=['GET'])
def listemployees():
    employees_names_list=[]
    con = sqlite3.connect(databasename, uri=True)
    cur2 = con.cursor()
    cur2.execute('select * from '+ emplyees_table)
    records = cur2.fetchall()
    for row in records:
        employees_names_list.append(row[8])
    cur2.close()
    con.close()
    resp = jsonify(employees_names_list = employees_names_list)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/listemployeesdata', methods=['GET'])
def listemployeesdata():
    employees_IDs_list=[]
    employees_names_list=[]
    con = sqlite3.connect(databasename, uri=True)
    cur2 = con.cursor()
    cur2.execute('select * from '+ emplyees_table)
    records = cur2.fetchall()
    for row in records:
        employees_IDs_list.append(row[3])
        employees_names_list.append(row[8])
    cur2.close()
    con.close()
    resp = jsonify(employees_IDs_list = employees_IDs_list , employees_names_list = employees_names_list)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

# id ,tasknumber ,employeeid ,vehicleid , deadline ,loadlocation , unloadlocation ,taskdescription , approved
@app.route('/listtasksdata', methods=['GET','POST'])
def listtasksdata():
    tasks_numbers_list=[]
    loadlocations_list=[]
    unloadlocations_list=[]
    deadlines_list=[]
    approved_list=[]
    started_list=[]
    finished_list=[]
    distance_list=[]
    status_list=[]
    vehicleids_list=[]
    con = sqlite3.connect(databasename, uri=True)
    cur2 = con.cursor()
    if request.method == 'POST':        
        print("listtasksdata POST")
        usertype = str(request.args.get('usertype'))
        username = str(request.args.get('username'))
        userid = str(request.args.get('userid'))
        if usertype == "employee":
            cur2.execute('select * from '+ tasks_table +' where employeeid = ? order by loaddate DESC ', (userid,))
        if usertype == "customer":
            cur2.execute('select * from '+ tasks_table +' where customerid = ? order by loaddate DESC ', (userid,))
        if usertype == "admin":
            cur2.execute('select * from '+ tasks_table + ' order by loaddate DESC ') 
    else:
        cur2.execute('select * from '+ tasks_table + ' order by loaddate DESC ')
    records = cur2.fetchall()
    for row in records:
        tasks_numbers_list.append(str(row[1]))
        vehicleids_list.append(row[3])
        deadlines_list.append(row[4])
        loadlocations_list.append(row[5])
        unloadlocations_list.append(row[6])
        approved_list.append(str(row[8]))
        finished_list.append(str(row[9]))
        started_list.append(str(row[12]))
        distance_list.append(str(row[13]))
        status_list.append(str(row[19]))
    cur2.close()
    con.close()
    print(tasks_numbers_list,loadlocations_list,unloadlocations_list,deadlines_list)
    resp = jsonify(tasks_numbers_list = tasks_numbers_list , loadlocations_list = loadlocations_list, unloadlocations_list = unloadlocations_list , deadlines_list = deadlines_list, approved_list =approved_list,finished_list = finished_list, started_list = started_list , distance_list = distance_list,status_list=status_list,vehicleids_list=vehicleids_list)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/listvehicles', methods=['GET'])
def listvehicles():
    wehicles_ids_list=[]
    con = sqlite3.connect(databasename, uri=True)
    cur2 = con.cursor()
    cur2.execute('select * from '+ vehicles_table)
    records = cur2.fetchall()
    for row in records:
        wehicles_ids_list.append(row[1])
    cur2.close()
    con.close()
    resp = jsonify(vehicles_ids_list = wehicles_ids_list)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

# getuserdata
@app.route('/getuserdata', methods=['POST'])
def getuserdata():
    firstname = ""
    lastname = ""
    birthday = ""
    phone = ""
    email = ""
    nationalnumber = ""
    username = ""
    password = ""

    tablename = ""
    if request.method == 'POST':
        print("getuserdata POST")

        username = request.args.get('username')          
        usertype = request.args.get('usertype')          
        con = sqlite3.connect(databasename, uri=True)
        cur2 = con.cursor()
        cur2.execute('select * from '+ admins_table +' where username = ? ', (username,))
        record = cur2.fetchall()
        if len(record)>0:
            tablename = admins_table
        cur2.execute('select * from '+ emplyees_table +' where username = ? ', (username,))
        record = cur2.fetchall()
        if len(record)>0:
            tablename = emplyees_table
        cur2.execute('select * from '+ customers_table +' where username = ? ', (username,))
        record = cur2.fetchall()
        if len(record)>0:
            tablename = customers_table
        
        cur2.execute('select * from '+ tablename +' where username = ? ', (username,))

        record = cur2.fetchall()[0]
        email = record[1]
        password = record[2] 
        nationalnumber =record[3]
        birthday = record[4] 
        phone = record[5]
        firstname = record[6]
        lastname = record[7] 
        username = record[8]

        cur2.close()
        con.close()

    resp = jsonify(email = email ,password = password, nationalnumber = nationalnumber ,birthday = birthday ,phone = phone ,firstname = firstname ,lastname = lastname,username=username)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/getEmployeeData', methods=['POST'])
def getEmployeeData():
    firstname = ""
    lastname = ""
    birthday = ""
    phone = ""
    email = ""
    nationalnumber = ""
    username = ""
    password = ""

    if request.method == 'POST':
        print("getEmployeeData POST")

        username = request.args.get('username')          
        usertype = request.args.get('usertype')          
        con = sqlite3.connect(databasename, uri=True)
        cur2 = con.cursor()
        if usertype == "customer":
            cur2.execute('select * from '+ customers_table +' where username = ? ', (username,))
        if usertype == "employee":
            cur2.execute('select * from '+ emplyees_table +' where username = ? ', (username,))
        if usertype == "admin":
            cur2.execute('select * from '+ emplyees_table +' where username = ? ', (username,))
        
        record = cur2.fetchall()[0]
        email = record[1]
        password = record[2] 
        nationalnumber =record[3]
        birthday = record[4] 
        phone = record[5]
        firstname = record[6]
        lastname = record[7] 
        username = record[8]

        cur2.close()
        con.close()

    resp = jsonify(email = email ,password = password, nationalnumber = nationalnumber ,birthday = birthday ,phone = phone ,firstname = firstname ,lastname = lastname,username=username)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/getcustomerdata', methods=['POST'])
def getcustomerdata():
    firstname = ""
    lastname = ""
    birthday = ""
    phone = ""
    email = ""
    nationalnumber = ""
    username = ""
    password = ""

    if request.method == 'POST':
        print("getcustomerdata POST")

        username = request.args.get('username')          
        con = sqlite3.connect(databasename, uri=True)
        cur2 = con.cursor()
        cur2.execute('select * from '+ customers_table +' where username = ? ', (username,))
        record = cur2.fetchall()[0]
        email = record[1]
        password = record[2] 
        nationalnumber =record[3]
        birthday = record[4] 
        phone = record[5]
        firstname = record[6]
        lastname = record[7] 
        username = record[8]

        cur2.close()
        con.close()

    resp = jsonify(email = email ,password = password, nationalnumber = nationalnumber ,birthday = birthday ,phone = phone ,firstname = firstname ,lastname = lastname,username=username)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp


@app.route('/getvehicledata', methods=['POST'])
def getvehicledata():
    vehicleID = ""
    manufacturer = ""
    modelyear = ""
    color = ""
    sizee = ""
    trackerid = ""
        
    if request.method == 'POST':
        print("getvehicledata POST")

        vehicleID = request.args.get('vehicleID')          
        con = sqlite3.connect(databasename, uri=True)
        cur2 = con.cursor()
        cur2.execute('select * from '+ vehicles_table +' where vehicleID = ? ', (vehicleID,))
        record = cur2.fetchall()[0]
        manufacturer = record[2]
        modelyear = str(record[3])
        color =record[4]
        sizee = record[5] 
        trackerid = record[6] 
        
        cur2.close()
        con.close()

    resp = jsonify(vehicleID = vehicleID ,manufacturer = manufacturer, modelyear = modelyear ,color = color ,sizee = sizee , trackerid = trackerid)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

# id ,tasknumber ,employeeid ,vehicleid , deadline ,loadlocation , unloadlocation ,taskdescription , approved

@app.route('/gettaskdata', methods=['POST'])
def gettaskdata():
    tasknumber = ""
    employeeid = ""
    vehicleid = ""
    deadline = ""
    loadlocation = ""
    unloadlocation = ""
    taskdescription = ""
    approved = ""
    finished = ""
    loaddate = ""
    unloaddate = ""
    started = ""
    status = ""
    approveddate = ""
    starteddate = ""
    loadeddate = ""
    unloadeddate = ""
    finisheddate = ""
    
    if request.method == 'POST':
        print("gettaskdata POST")

        tasknumber = request.args.get('tasknumber')          
        con = sqlite3.connect(databasename, uri=True)
        cur2 = con.cursor()
        cur2.execute('select * from '+ tasks_table +' where tasknumber = ? order by loaddate DESC', (tasknumber,))
        record = cur2.fetchall()[0]
        tasknumber = str(record[1])
        employeeid = record[2]
        vehicleid = record[3]
        deadline = record[4]
        loadlocation = record[5]
        unloadlocation = record[6]
        taskdescription = record[7]
        approved = record[8]
        finished = record[9]
        loaddate = record[11]
        started = record[12]
        status = record[19]
        approveddate = record[20]
        starteddate = record[21]
        loadeddate = record[22]
        unloadeddate = record[23]
        finisheddate = record[24]
        unloaddate = record[25]
       
        cur2.close()
        con.close()

    resp = jsonify(tasknumber =tasknumber,employeeid=employeeid ,vehicleid=vehicleid , deadline=deadline ,loadlocation=loadlocation , unloadlocation=unloadlocation ,taskdescription=taskdescription , approved =approved ,finished=finished,loaddate=loaddate ,started=started,status = status, approveddate = approveddate, starteddate = starteddate, loadeddate = loadeddate, unloadeddate = unloadeddate , finisheddate = finisheddate , unloaddate = unloaddate)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp


@app.route('/updateuser', methods=['POST'])
def updateuser():
    print("updateuser")
    success = False
    message = ""
    status = 0 
    if request.method == 'POST':
        print("post") 
        if not "firstname" in request.args:
            message = "Invalid firstname"
            status = -10 
        if not "lastname" in request.args:
            message = "Invalid lastname"
            status = -11 
        if not "birthday" in request.args:
            message = "Invalid birthday"
            status = -12 
        if not "phone" in request.args:
            message = "Invalid phone"
            status = -13 
        if not "email" in request.args:
            message = "Invalid email"
            status = -14 
        if not "nationalnumber" in request.args:
            message = "Invalid national number"
            status = -15 
        if not "username" in request.args:
            message = "Invalid username"
            status = -16 
        if not "password" in request.args:
            message = "Invalid password"
            status = -17 
        # if not "usertable" in request.args:
        #     message = "Invalid usertable"
        #     status = -18 


        if status == 0: # all inputs are valid
            originalusername = request.args.get('originalusername')
            firstname = request.args.get('firstname')
            lastname = request.args.get('lastname')
            birthday = request.args.get('birthday')
            phone = request.args.get('phone')
            email = request.args.get('email')
            nationalnumber = request.args.get('nationalnumber')
            username = request.args.get('username')
            password = request.args.get('password')
            # usertable = request.args.get('usertable')
            if firstname == "" or len(firstname) < 3: 
                message = "Invalid firstname" 
                status = -20
            if lastname == "" or len(lastname) < 3:
                message = "Invalid lastname"
                status = -21 
            if  birthday == "" or len(birthday) < 3:
                message = "Invalid birthday"
                status = -22 
            if  len(phone) != 10 :
                message = "Invalid phone"
                status = -23 
            else:
                if phone[0] != "0":
                    message = "Invalid phone"
                    status = -23
            if  email == "" or len(email) < 3 or email.find('@')<0 or email.find('.')<0 :
                message = "Invalid email"
                status = -24 
            if  len(nationalnumber) != 10:
                message = "Invalid national number"
                status = -25 
            else:
                if nationalnumber[0] != "1" and nationalnumber[0] != "2":
                    message = "Invalid national number"
                    status = -25 
            if  username == "" or len(username) < 3:
                message = "Invalid username"
                status = -26 
            if  password == "" or len(password) < 3:
                message = "Invalid password"
                status = -27 
            if status == 0:
                con = sqlite3.connect(databasename, uri=True)
                cur2 = con.cursor()
                
                

                cur2.execute('select * from '+ admins_table +' where username = ? ', (username,))
                records2 = cur2.fetchall()
                cur2.execute('select * from '+ admins_table +' where email = ? and username != ?', (email,originalusername,))
                records3 = cur2.fetchall()
                cur2.execute('select * from '+ admins_table +' where nationalnumber = ? and username != ?', (nationalnumber,originalusername,))
                records4 = cur2.fetchall()
                cur2.execute('select * from '+ admins_table +' where phone = ? and username != ?', (phone,originalusername,))
                records5 = cur2.fetchall()
                if len(records2) > 0 and username != originalusername: # new username already exists
                    message = "Duplicated username"
                    status = -2
                elif len(records3) > 0 : # new email already exists
                    message = "Duplicated email"
                    status = -3
                elif len(records4) > 0 : # new national number already exists
                    message = "Duplicated national number"
                    status = -4
                elif len(records5) > 0 : # new phone already exists
                    message = "Duplicated phone"
                    status = -5
                
                cur2.execute('select * from '+ emplyees_table +' where username = ? ', (username,))
                records2 = cur2.fetchall()
                cur2.execute('select * from '+ emplyees_table +' where email = ? and username != ?', (email,originalusername,))
                records3 = cur2.fetchall()
                cur2.execute('select * from '+ emplyees_table +' where nationalnumber = ? and username != ?', (nationalnumber,originalusername,))
                records4 = cur2.fetchall()
                cur2.execute('select * from '+ emplyees_table +' where phone = ? and username != ?', (phone,originalusername,))
                records5 = cur2.fetchall()
                if len(records2) > 0 and username != originalusername: # new username already exists
                    message = "Duplicated username"
                    status = -2
                elif len(records3) > 0 : # new email already exists
                    message = "Duplicated email"
                    status = -3
                elif len(records4) > 0 : # new national number already exists
                    message = "Duplicated national number"
                    status = -4
                elif len(records5) > 0 : # new phone already exists
                    message = "Duplicated phone"
                    status = -5
                
                cur2.execute('select * from '+ customers_table +' where username = ? ', (username,))
                records2 = cur2.fetchall()
                cur2.execute('select * from '+ customers_table +' where email = ? and username != ?', (email,originalusername,))
                records3 = cur2.fetchall()
                cur2.execute('select * from '+ customers_table +' where nationalnumber = ? and username != ?', (nationalnumber,originalusername,))
                records4 = cur2.fetchall()
                cur2.execute('select * from '+ customers_table +' where phone = ? and username != ?', (phone,originalusername,))
                records5 = cur2.fetchall()
                if len(records2) > 0 and username != originalusername: # new username already exists
                    message = "Duplicated username"
                    status = -2
                elif len(records3) > 0 : # new email already exists
                    message = "Duplicated email"
                    status = -3
                elif len(records4) > 0 : # new national number already exists
                    message = "Duplicated national number"
                    status = -4
                elif len(records5) > 0 : # new phone already exists
                    message = "Duplicated phone"
                    status = -5
                # id ,email ,password , nationalnumber ,birthday ,phone ,firstname ,lastname ,username 
                
                if status == 0: # store employee
                    cur2.execute('select * from '+ admins_table +' where username = ? ', (originalusername,))
                    records = cur2.fetchall()
                    if len(records)>0:
                        usertable = admins_table
                    cur2.execute('select * from '+ emplyees_table +' where username = ? ', (originalusername,))
                    records = cur2.fetchall()
                    if len(records)>0:
                        usertable = emplyees_table
                    cur2.execute('select * from '+ customers_table +' where username = ? ', (originalusername,))
                    records = cur2.fetchall()
                    if len(records)>0:
                        usertable = customers_table
                    
                    cur2.execute('UPDATE ' + usertable + ' SET firstname = ? , lastname = ? , birthday = ? , phone = ? , email = ? , nationalnumber = ? , username = ? , password = ? WHERE username = ? ', (firstname,lastname,birthday,phone,email,nationalnumber,username,password,originalusername,))
                    con.commit()
                    success = True
                    status = 1
                cur2.close()
                con.close()        
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp
   
# @app.route('/updateemployee', methods=['POST'])
# def updateemployee():
#     print("updateemployee")
#     success = False
#     message = ""
#     status = 0 
#     if request.method == 'POST':
#         print("post") 
#         if not "firstname" in request.args:
#             message = "Invalid firstname"
#             status = -10 
#         if not "lastname" in request.args:
#             message = "Invalid lastname"
#             status = -11 
#         if not "birthday" in request.args:
#             message = "Invalid birthday"
#             status = -12 
#         if not "phone" in request.args:
#             message = "Invalid phone"
#             status = -13 
#         if not "email" in request.args:
#             message = "Invalid email"
#             status = -14 
#         if not "nationalnumber" in request.args:
#             message = "Invalid national number"
#             status = -15 
#         if not "username" in request.args:
#             message = "Invalid username"
#             status = -16 
#         if not "password" in request.args:
#             message = "Invalid password"
#             status = -17 


#         if status == 0: # all inputs are valid
#             originalusername = request.args.get('originalusername')
#             firstname = request.args.get('firstname')
#             lastname = request.args.get('lastname')
#             birthday = request.args.get('birthday')
#             phone = request.args.get('phone')
#             email = request.args.get('email')
#             nationalnumber = request.args.get('nationalnumber')
#             username = request.args.get('username')
#             password = request.args.get('password')
#             if firstname == "" or len(firstname) < 3: 
#                 message = "Invalid firstname" 
#                 status = -20
#             if lastname == "" or len(lastname) < 3:
#                 message = "Invalid lastname"
#                 status = -21 
#             if  birthday == "" or len(birthday) < 3:
#                 message = "Invalid birthday"
#                 status = -22 
#             if  len(phone) != 10 :
#                 message = "Invalid phone"
#                 status = -23 
#             else:
#                 if phone[0] != "0":
#                     message = "Invalid phone"
#                     status = -23
#             if  email == "" or len(email) < 3 or email.find('@')<0 or email.find('.')<0 :
#                 message = "Invalid email"
#                 status = -24 
#             if  len(nationalnumber) != 10:
#                 message = "Invalid national number"
#                 status = -25 
#             else:
#                 if nationalnumber[0] != "1" and nationalnumber[0] != "2":
#                     message = "Invalid national number"
#                     status = -25 
#             if  username == "" or len(username) < 3:
#                 message = "Invalid username"
#                 status = -26 
#             if  password == "" or len(password) < 3:
#                 message = "Invalid password"
#                 status = -27 
#             if status == 0:
#                 con = sqlite3.connect(databasename, uri=True)
#                 cur2 = con.cursor()
                
#                 cur2.execute('select * from '+ emplyees_table +' where username = ? ', (username,))
#                 records2 = cur2.fetchall()
#                 cur2.execute('select * from '+ emplyees_table +' where email = ? and username != ?', (email,originalusername,))
#                 records3 = cur2.fetchall()
#                 cur2.execute('select * from '+ emplyees_table +' where nationalnumber = ? and username != ?', (nationalnumber,originalusername,))
#                 records4 = cur2.fetchall()
#                 cur2.execute('select * from '+ emplyees_table +' where phone = ? and username != ?', (phone,originalusername,))
#                 records5 = cur2.fetchall()
#                 if len(records2) > 0 and username != originalusername: # new username already exists
#                     message = "Duplicated username"
#                     status = -2
#                 elif len(records3) > 0 : # new email already exists
#                     message = "Duplicated email"
#                     status = -3
#                 elif len(records4) > 0 : # new national number already exists
#                     message = "Duplicated national number"
#                     status = -4
#                 elif len(records5) > 0 : # new phone already exists
#                     message = "Duplicated phone"
#                     status = -5

#                 # id ,email ,password , nationalnumber ,birthday ,phone ,firstname ,lastname ,username 
                
#                 else: # store employee
#                     cur2.execute('UPDATE ' + emplyees_table + ' SET firstname = ? , lastname = ? , birthday = ? , phone = ? , email = ? , nationalnumber = ? , username = ? , password = ? WHERE username = ? ', (firstname,lastname,birthday,phone,email,nationalnumber,username,password,originalusername,))
#                     con.commit()
#                     success = True
#                     status = 1
#                 cur2.close()
#                 con.close()        
#     resp = jsonify(success = success , message = message , status = status)
#     resp.status_code = 200
#     resp.headers.add("Access-Control-Allow-Origin", "*") 
#     return resp

# @app.route('/updatecustomer', methods=['POST'])
# def updatecustomer():
#     print("updatecustomer")
#     success = False
#     message = ""
#     status = 0 
#     if request.method == 'POST':
#         print("post") 
#         if not "firstname" in request.args:
#             message = "Invalid firstname"
#             status = -10 
#         if not "lastname" in request.args:
#             message = "Invalid lastname"
#             status = -11 
#         if not "birthday" in request.args:
#             message = "Invalid birthday"
#             status = -12 
#         if not "phone" in request.args:
#             message = "Invalid phone"
#             status = -13 
#         if not "email" in request.args:
#             message = "Invalid email"
#             status = -14 
#         if not "nationalnumber" in request.args:
#             message = "Invalid national number"
#             status = -15 
#         if not "username" in request.args:
#             message = "Invalid username"
#             status = -16 
#         if not "password" in request.args:
#             message = "Invalid password"
#             status = -17 


#         if status == 0: # all inputs are valid
#             originalusername = request.args.get('originalusername')
#             firstname = request.args.get('firstname')
#             lastname = request.args.get('lastname')
#             birthday = request.args.get('birthday')
#             phone = request.args.get('phone')
#             email = request.args.get('email')
#             nationalnumber = request.args.get('nationalnumber')
#             username = request.args.get('username')
#             password = request.args.get('password')
#             if firstname == "" or len(firstname) < 3: 
#                 message = "Invalid firstname" 
#                 status = -20
#             if lastname == "" or len(lastname) < 3:
#                 message = "Invalid lastname"
#                 status = -21 
#             if  birthday == "" or len(birthday) < 3:
#                 message = "Invalid birthday"
#                 status = -22 
#             if  len(phone) != 10 :
#                 message = "Invalid phone"
#                 status = -23 
#             else:
#                 if phone[0] != "0":
#                     message = "Invalid phone"
#                     status = -23
#             if  email == "" or len(email) < 3 or email.find('@')<0 or email.find('.')<0 :
#                 message = "Invalid email"
#                 status = -24 
#             if  len(nationalnumber) != 10:
#                 message = "Invalid national number"
#                 status = -25 
#             else:
#                 if nationalnumber[0] != "1" and nationalnumber[0] != "2":
#                     message = "Invalid national number"
#                     status = -25 
#             if  username == "" or len(username) < 3:
#                 message = "Invalid username"
#                 status = -26 
#             if  password == "" or len(password) < 3:
#                 message = "Invalid password"
#                 status = -27 
#             if status == 0:
#                 con = sqlite3.connect(databasename, uri=True)
#                 cur2 = con.cursor()
#                 cur2.execute('select * from '+ customers_table +' where username = ? ', (username,))
#                 records2 = cur2.fetchall()
#                 cur2.execute('select * from '+ customers_table +' where email = ? and username != ?', (email,originalusername,))
#                 records3 = cur2.fetchall()
#                 cur2.execute('select * from '+ customers_table +' where nationalnumber = ? and username != ?', (nationalnumber,originalusername,))
#                 records4 = cur2.fetchall()
#                 cur2.execute('select * from '+ customers_table +' where phone = ? and username != ?', (phone,originalusername,))
#                 records5 = cur2.fetchall()
#                 if len(records2) > 0 and username != originalusername: # new username already exists
#                     message = "Duplicated username"
#                     status = -2
#                 elif len(records3) > 0 : # new email already exists
#                     message = "Duplicated email"
#                     status = -3
#                 elif len(records4) > 0 : # new national number already exists
#                     message = "Duplicated national number"
#                     status = -4
#                 elif len(records5) > 0 : # new phone already exists
#                     message = "Duplicated phone"
#                     status = -5

#                 # id ,email ,password , nationalnumber ,birthday ,phone ,firstname ,lastname ,username 
                
#                 else: # store employee
#                     cur2.execute('UPDATE ' + customers_table + ' SET firstname = ? , lastname = ? , birthday = ? , phone = ? , email = ? , nationalnumber = ? , username = ? , password = ? WHERE username = ? ', (firstname,lastname,birthday,phone,email,nationalnumber,username,password,originalusername,))
#                     con.commit()
#                     success = True
#                     status = 1
#                 cur2.close()
#                 con.close()        
#     resp = jsonify(success = success , message = message , status = status)
#     resp.status_code = 200
#     resp.headers.add("Access-Control-Allow-Origin", "*") 
#     return resp

# vehicleID ,manufacturer ,  modelyear , color , sizee 
@app.route('/updatevehicle', methods=['POST'])
def updatevehicle():
    print("updatevehicle")
    success = False
    message = ""
    status = 0 
    if request.method == 'POST':
        print("post") 
        if not "vehicleID" in request.args:
            message = "Invalid vehicleID"
            status = -10 
        if not "manufacturer" in request.args:
            message = "Invalid manufacturer"
            status = -11 
        if not "modelyear" in request.args:
            message = "Invalid modelyear"
            status = -12 
        if not "color" in request.args:
            message = "Invalid color"
            status = -13 
        if not "sizee" in request.args:
            message = "Invalid sizee"
            status = -14 
        if not "trackerid" in request.args:
            message = "Invalid tracker id"
            status = -15 

        if status == 0: # all inputs are valid
            originalvehicleID = request.args.get('originalvehicleID')
            vehicleID = request.args.get('vehicleID')
            manufacturer = request.args.get('manufacturer')
            modelyear = request.args.get('modelyear')
            color = request.args.get('color')
            sizee = request.args.get('sizee')
            trackerid = request.args.get('trackerid')
            if vehicleID == "" or len(vehicleID) < 3: 
                message = "Invalid vehicleID" 
                status = -20
            if manufacturer == "" or len(manufacturer) < 3:
                message = "Invalid manufacturer"
                status = -21 
            if  modelyear == "" or len(modelyear) < 3:
                message = "Invalid modelyear"
                status = -22 
            if  color == "" or len(color) < 3:
                message = "Invalid color"
                status = -23 
            if  sizee == "" or len(sizee) < 3:
                message = "Invalid sizee"
                status = -24 
            if  trackerid == "" :
                message = "Invalid tracker id"
                status = -25 
                
            if status == 0:
                con = sqlite3.connect(databasename, uri=True)
                cur2 = con.cursor()
                cur2.execute('select * from '+ vehicles_table +' where vehicleID = ? ', (originalvehicleID,))
                records_old_id = cur2.fetchall()
                cur2.execute('select * from '+ vehicles_table +' where vehicleID = ? ', (vehicleID,))
                records_new_id = cur2.fetchall()
                if len(records_new_id) > 0 and originalvehicleID != vehicleID:
                    message = "Duplicated vehicleID"
                    status = -2
                
                else: # store employee
                    cur2.execute('UPDATE ' + vehicles_table + ' SET vehicleID = ? , manufacturer = ? , modelyear = ? , color = ? , size = ? ,trackerid =? WHERE vehicleID = ? ', (vehicleID,manufacturer,modelyear,color,sizee,trackerid,originalvehicleID,))
                    con.commit()
                    success = True
                    status = 1
                cur2.close()
                con.close()        
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp


@app.route('/updatetask', methods=['POST'])
def updatetask():
    print("updatetask")
    success = False
    message = ""
    status = 0 
    if request.method == 'POST':
        print("post") 
        if not "tasknumber" in request.args:
            message = "Invalid task number"
            status = -10 
        if not "employeeid" in request.args:
            message = "Invalid employee id"
            status = -11 
        if not "vehicleid" in request.args:
            message = "Invalid vehicle id"
            status = -12 
        if not "deadline" in request.args:
            message = "Invalid deadline"
            status = -13 
        if not "loadlocation" in request.args:
            message = "Invalid loadlocation"
            status = -14 
        if not "unloadlocation" in request.args:
            message = "Invalid unload location"
            status = -15 
        if not "taskdescription" in request.args:
            message = "Invalid task description"
            status = -16

        if status == 0: # all inputs are valid
            originaltasknumber = request.args.get('originaltasknumber')
            tasknumber = request.args.get('tasknumber')
            employeeid = request.args.get('employeeid')
            vehicleid = request.args.get('vehicleid')
            deadline = request.args.get('deadline')
            loadlocation = request.args.get('loadlocation')
            unloadlocation = request.args.get('unloadlocation')
            taskdescription = request.args.get('taskdescription')

            if tasknumber == "" or len(tasknumber) < 3: 
                message = "Invalid task number" 
                status = -20
            if employeeid == "" or len(employeeid) < 3:
                message = "Invalid employee id"
                status = -21 
            if  vehicleid == "" or len(vehicleid) < 3:
                message = "Invalid vehicle id"
                status = -22 
            if  deadline == "" or len(deadline) < 3:
                message = "Invalid deadline"
                status = -23 
            if  loadlocation == "" or len(loadlocation) < 3:
                message = "Invalid load location"
                status = -24 
            if  unloadlocation == "" or len(unloadlocation) < 3:
                message = "Invalid unload location"
                status = -25 
            if  taskdescription == "" or len(taskdescription) < 3:
                message = "Invalid task description"
                status = -26 

            if status == 0:
                key = "AIzaSyAjdw0zgEfP606e0tm1dJ3uXrYCP7-dzxo"
                api_response = requests.get('https://maps.googleapis.com/maps/api/geocode/json?address={0}&key={1}'.format(unloadlocation, key))
                api_response_dict = api_response.json()

                if api_response_dict['status'] == 'OK':
                    unloadlatbyuser = api_response_dict['results'][0]['geometry']['location']['lat']
                    unloadlngbyuser = api_response_dict['results'][0]['geometry']['location']['lng']
                else:
                    unloadlatbyuser = ""
                    unloadlngbyuser = ""
                
                api_response = requests.get('https://maps.googleapis.com/maps/api/geocode/json?address={0}&key={1}'.format(loadlocation, key))
                api_response_dict = api_response.json()

                con = sqlite3.connect(databasename, uri=True)
                cur2 = con.cursor()
                
                cur2.execute('select * from '+ tasks_table +' where tasknumber = ? order by loaddate DESC', (originaltasknumber,))
                records_old_id = cur2.fetchall()
                cur2.execute('select * from '+ tasks_table +' where tasknumber = ? order by loaddate DESC', (tasknumber,))
                records_new_id = cur2.fetchall()
                if len(records_new_id) > 0 and originaltasknumber != tasknumber:
                    message = "Duplicated Task Number"
                    status = -2
                # id ,tasknumber ,employeeid ,vehicleid , deadline ,loadlocation , unloadlocation ,taskdescription , approved
                else: # store employee
                    cur2.execute('UPDATE ' + tasks_table + ' SET tasknumber = ? , employeeid = ? , vehicleid = ? , deadline = ? , loadlocation = ? , unloadlocation = ? , taskdescription = ? , unloadlatbyuser =? , unloadlngbyuser = ? WHERE tasknumber = ? ', (tasknumber ,employeeid ,vehicleid , deadline ,loadlocation , unloadlocation ,taskdescription,unloadlatbyuser,unloadlngbyuser,originaltasknumber,))
                    con.commit()
                    success = True
                    status = 1
                cur2.close()
                con.close()        
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/updatetaskbycustomer', methods=['POST'])
def updatetaskbycustomer():
    print("updatetaskbycustomer")
    success = False
    message = ""
    status = 0 
    if request.method == 'POST':
        print("post") 
        if not "loaddate" in request.args:
            message = "Invalid load date"
            status = -12 
        if not "unloaddate" in request.args:
            message = "Invalid unload date"
            status = -122 
        if not "deadline" in request.args:
            message = "Invalid deadline"
            status = -13 
        if not "loadlocation" in request.args:
            message = "Invalid loadlocation"
            status = -14 
        if not "taskdescription" in request.args:
            message = "Invalid task description"
            status = -16

        if status == 0: # all inputs are valid
            originaltasknumber = request.args.get('originaltasknumber')
            loaddate = request.args.get('loaddate')
            unloaddate = request.args.get('unloaddate')
            deadline = request.args.get('deadline')
            loadlocation = request.args.get('loadlocation')
            taskdescription = request.args.get('taskdescription')

            if  loaddate == "" or len(loaddate) < 3:
                message = "Invalid load date"
                status = -22 
            if  unloaddate == "" or len(unloaddate) < 3:
                message = "Invalid load date"
                status = -222 
            if  deadline == "" or len(deadline) < 3:
                message = "Invalid deadline"
                status = -23 
            if  loadlocation == "" or len(loadlocation) < 3:
                message = "Invalid load location"
                status = -24 
            if  taskdescription == "" or len(taskdescription) < 3:
                message = "Invalid task description"
                status = -26 

            if status == 0:
                con = sqlite3.connect(databasename, uri=True)
                cur2 = con.cursor()
                cur2.execute('UPDATE ' + tasks_table + ' SET loaddate = ? ,unloaddate = ? , deadline = ? , loadlocation = ? , taskdescription = ?  WHERE tasknumber = ? ', (loaddate ,unloaddate, deadline ,loadlocation , taskdescription,originaltasknumber,))
                con.commit()
                success = True
                status = 1
                cur2.close()
                con.close()        
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/approvetask', methods=['POST'])
def approvetask():
    print("approvetask")
    success = False
    message = ""
    status = 0 
    if request.method == 'POST':
        print("post") 
        if not "tasknumber" in request.args:
            message = "Invalid task number"
            status = -10 
        
        if status == 0: # all inputs are valid
            tasknumber = request.args.get('tasknumber')
        
            if tasknumber == "" or len(tasknumber) < 3: 
                message = "Invalid task number" 
                status = -20
            
            if status == 0:
                con = sqlite3.connect(databasename, uri=True)
                cur2 = con.cursor()
                cur2.execute('UPDATE ' + tasks_table + ' SET approved = ? , status = ? ,approveddate = ? WHERE tasknumber = ? ', (True ,"approved" ,datetime.now()+timedelta(hours=3),tasknumber ,))
                con.commit()
                success = True
                status = 1
                cur2.close()
                con.close()        
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp



#    + tasks_table + ' (id INTEGER PRIMARY KEY AUTOINCREMENT,tasknumber TEXT,employeeid TEXT ,vehicleid TEXT, deadline TEXT,loadlocation TEXT, unloadlocation TEXT,taskdescription TEXT, approved boolean default False, finished boolean default False,customerid TEXT, loaddate TEXT, started boolean default False)')

@app.route('/deleteemployee', methods=['POST'])
def deleteemployee():
    success = False
    message = ""
    status = 0 
    if request.method == 'POST':
        username = request.args.get('username')
        con = sqlite3.connect(databasename, uri=True)
        
        cur2 = con.cursor()
        cur2.execute('select nationalnumber from '+ emplyees_table +' where username = ? ', (username,))
        records = cur2.fetchall()
        employeeid = records[0][0]

        cur2.execute('select * from '+ tasks_table +' where employeeid = ? and finished = ? order by loaddate DESC', (employeeid,False,))
        records = cur2.fetchall()
        if len(records) > 0 :
            message = "Can't delete an empolyee with an ongoing Task."
        else:
            cur2.execute('DELETE from ' + emplyees_table + ' where username = ? ', (username,))
            con.commit()
            success = True
            status = 1
        
        cur2.close()
        con.close()
        success = True
        status = 1
    
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/deletevehicle', methods=['POST'])
def deletevehicle():
    success = False
    message = ""
    status = 0 
    if request.method == 'POST':
        vehicleID = request.args.get('vehicleID')
        con = sqlite3.connect(databasename, uri=True)
        cur2 = con.cursor()
        cur2.execute('DELETE from ' + vehicles_table + ' where vehicleID = ? ', (vehicleID,))
        con.commit()
        cur2.close()
        con.close()
        success = True
        status = 1

    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/deletetask', methods=['POST'])
def deletetask():
    success = False
    message = ""
    status = 0 
    if request.method == 'POST':
        tasknumber = request.args.get('tasknumber')
        con = sqlite3.connect(databasename, uri=True)
        cur2 = con.cursor()
        cur2.execute('DELETE from ' + tasks_table + ' where tasknumber = ? ', (tasknumber,))
        con.commit()
        cur2.close()
        con.close()
        success = True
        status = 1

    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/starttask', methods=['POST'])
def starttask():
    print("starttask")
    success = False
    message = ""
    status = 0 
    if request.method == 'POST':
        if not "tasknumber" in request.args:
            message = "Invalid task number"
            status = -10 
        
        if status == 0: # all inputs are valid
            originaltasknumber = request.args.get('tasknumber')
        
            if status == 0:
                con = sqlite3.connect(databasename, uri=True)
                cur2 = con.cursor()
                print("starting task in database")
                # id ,tasknumber ,employeeid ,vehicleid , deadline ,loadlocation , unloadlocation ,taskdescription , approved
                cur2.execute('UPDATE ' + tasks_table + ' SET started = ? , status =? , starteddate = ? WHERE tasknumber = ? ', (True,"started",datetime.now()+timedelta(hours=3),originaltasknumber,))
                con.commit()
                success = True
                status = 1
                cur2.close()
                con.close()        
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp


@app.route('/finishtask', methods=['POST'])
def finishtask():
    print("finishtask")
    success = False
    message = ""
    status = 0 
    if request.method == 'POST':
        if not "tasknumber" in request.args:
            message = "Invalid task number"
            status = -10 
        
        if status == 0: # all inputs are valid
            originaltasknumber = request.args.get('tasknumber')
        
            if status == 0:
                con = sqlite3.connect(databasename, uri=True)
                cur2 = con.cursor()

                cur2.execute('select unloadeddate from '+ tasks_table +' where tasknumber = ? ', (originaltasknumber,))
                records = cur2.fetchall()
                if records[0][0] != "":
                    print("finishing task in database")
                    # id ,tasknumber ,employeeid ,vehicleid , deadline ,loadlocation , unloadlocation ,taskdescription , approved
                    cur2.execute('UPDATE ' + tasks_table + ' SET finished = ? , finisheddate = ? WHERE tasknumber = ? ', (True,datetime.now()+timedelta(hours=3),originaltasknumber,))
                    con.commit()
                    success = True
                    status = 1
                else:
                    success = False
                    status = -1
                    message = "Package not unloaded"
                cur2.close()
                con.close()        
    resp = jsonify(success = success , message = message , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

@app.route('/mapsautocomplete', methods=['POST'])
def mapsautocomplete():
    success = False
    suggestions = []
    suggestionsplaceid = []
    
    descriptions = ""
    status = 0 

    # gmaps = googlemaps.Client(key='MY_API_KEY')
    # place_id = "ChIJnQrgk4u6EmsRVqYSfnjhaOk"
    # # Geocoding an address
    # geocode_result = gmaps.reverse_geocode(place_id)

    if request.method == 'POST':
        if "input" in request.args:
            input = request.args.get('input')
            if input != "":
                # types = request.args.get('types')
                # language = request.args.get('language')
                key = "AIzaSyAjdw0zgEfP606e0tm1dJ3uXrYCP7-dzxo"
                # https://maps.googleapis.com/maps/api/place/autocomplete/json?input=egypt&types=address&key=AIzaSyAjdw0zgEfP606e0tm1dJ3uXrYCP7-dzxo&language=pt-Br
                url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=" + input + "&key="+key
                respond = requests.get(url=url)
                respondcontentjson = json.loads(respond.content)
                predictions = respondcontentjson["predictions"]
                print(respond)
                for prediction in predictions:
                    suggestions.append([prediction["description"]])
                    suggestionsplaceid.append([prediction["place_id"]])
                # print("predictions",predictions)

    # print(suggestions)
            
    resp = jsonify(success = success , suggestions = suggestions , status = status,suggestionsplaceid=suggestionsplaceid)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp



@app.route('/getroute', methods=['POST'])
def getroute():
    success = True
    northeast = {"lat":31.110484,"lng":72.384598}
    southwest = {"lat":31.110484,"lng":72.384598}
    mapcenter = {"lat":31.110484,"lng":72.384598}
    vehiclelocation = {"lat":31.110484,"lng":72.384598}
    markersList = [{"latitude":31.110484,"longitude":72.384598},{"latitude":31.110484,"longitude":75.384598}]
    polylinePoints = []

    suggestions = []
    descriptions = ""
    status = 0 

    if request.method == 'POST':        
        destination = request.args.get('destination')
        origin = request.args.get('origin')
        vehicleid = request.args.get('Vehicleid')

        con = sqlite3.connect(databasename, uri=True)
        cur2 = con.cursor()
        cur2.execute('select lat,lng from '+ vehicles_table +' where vehicleID = ? ', (vehicleid,))
        records = cur2.fetchall()
        
        if records[0][0] != None and records[0][1] != None:
            vehiclelocation = {"lat":float(records[0][0]),"lng":float(records[0][1])}

        cur2.close()
        con.close()  

        if input != "":
            # types = request.args.get('types')
            # language = request.args.get('language')
            key = "AIzaSyAjdw0zgEfP606e0tm1dJ3uXrYCP7-dzxo"
            # https://maps.googleapis.com/maps/api/place/autocomplete/json?input=egypt&types=address&key=AIzaSyAjdw0zgEfP606e0tm1dJ3uXrYCP7-dzxo&language=pt-Br
            # url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=" + input + "&key="+key
            url = "https://maps.googleapis.com/maps/api/directions/json?destination=" + destination + "&origin=" + origin + "&key=" + key
            respond = requests.get(url=url)
            # print(respond)
            respondcontent = respond.content
            print(respondcontent)
            # print("\n\n\n")
            respondcontentjson = json.loads(respondcontent)
            # print(respondcontentjson)
            # print("\n\n\n")
            # print(respondcontentjson["routes"][0]["legs"][0]["steps"])
            # print("\n\n\n")
            # print(respondcontentjson["routes"][0]["legs"][0]["steps"][0])

            northeast = {"lat":respondcontentjson["routes"][0]["bounds"]["northeast"]["lat"],"lng":respondcontentjson["routes"][0]["bounds"]["northeast"]["lng"]}
            southwest = {"lat":respondcontentjson["routes"][0]["bounds"]["southwest"]["lat"],"lng":respondcontentjson["routes"][0]["bounds"]["southwest"]["lng"]}
            mapcenter = {"lat":(respondcontentjson["routes"][0]["bounds"]["northeast"]["lat"]+respondcontentjson["routes"][0]["bounds"]["southwest"]["lat"])/2,"lng":(respondcontentjson["routes"][0]["bounds"]["northeast"]["lng"]+respondcontentjson["routes"][0]["bounds"]["southwest"]["lng"])/2}
            routes = respondcontentjson["routes"][0]["legs"][0]["steps"]
            for route in routes:
                polylinePoints.append(route["start_location"])
                polyline_subpoints = polyline.decode(route['polyline']['points'], 5)
                for polyline_subpoint in polyline_subpoints:
                    polylinePoints.append({"lat":polyline_subpoint[0],"lng":polyline_subpoint[1]})
                polylinePoints.append(route["end_location"])

    resp = jsonify(success = success , status = status , polylinePoints = polylinePoints , mapcenter = mapcenter , northeast = northeast , southwest = southwest, vehiclelocation = vehiclelocation )
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

# 127.0.0.1:13000/updatetrackerlocation?trackerid=tracker0123&lat=21.4009880893262&lng=39.4491033264495&distance=187
# 127.0.0.1:13000/updatetrackerlocation?trackerid=tracker0123&lat=21.4009880893262&lng=39.4491033264495&distance=10
# 127.0.0.1:13000/updatetrackerlocation?trackerid=tracker0123&lat=21.4009880893262&lng=39.4491033264495&distance=10
# 127.0.0.1:13000/updatetrackerlocation?trackerid=tracker0123&lat=21.4009880893262&lng=39.4491033264495&distance=10

@app.route('/updatetrackerlocation', methods=['GET'])
def updatetrackerlocation():
    success = True
    status = 0 

    trackerid = request.args.get('trackerid')
    lat = request.args.get('lat')
    lng = request.args.get('lng')
    distance = request.args.get('distance')

    # print(trackerid,lat,lng,distance)
    # print(type(trackerid),type(lat),type(lng),type(distance))

    con = sqlite3.connect(databasename, uri=True)
    cur2 = con.cursor()
    # tracker update vehicle
    cur2.execute('select vehicleID from '+ vehicles_table +' where trackerid = ? ', (trackerid,))
    records = cur2.fetchall()
    if len(records) > 0 :                
        vehicleID = records[0][0]
        cur2.execute('UPDATE ' + vehicles_table + ' SET lat = ? , lng = ? , distance = ? WHERE trackerid = ? ', (lat,lng,distance,trackerid,))
        con.commit()
        success = True
        status = 1
    
        cur2.execute('select tasknumber,unloadlatbyuser,unloadlngbyuser from '+ tasks_table +' where vehicleid = ? and approved = ? and started = ? and loadeddate =?', (vehicleID,True,True,""))
        records = cur2.fetchall()
        if len(records)>0:
            tasknumber = records[0][0]
            unloadlatbyuser = records[0][1]
            unloadlngbyuser = records[0][2]
            if len(records) > 0 :  
                cur2.execute('UPDATE ' + tasks_table + ' SET loadeddate = ? WHERE tasknumber = ? ', (datetime.now()+timedelta(hours=3),tasknumber,))
                con.commit()
                success = True
                status = 1

    # tracker and vehicle update task


        cur2.execute('select tasknumber,unloadlatbyuser,unloadlngbyuser from '+ tasks_table +' where vehicleid = ? and started = ? and finished = ? ', (vehicleID,True,False))
        records = cur2.fetchall()
        if len(records)>0:
            tasknumber = records[0][0]
            unloadlatbyuser = records[0][1]
            unloadlngbyuser = records[0][2]
            if len(records) > 0 :                
                cur2.execute('UPDATE ' + tasks_table + ' SET sensordistance = ? WHERE tasknumber = ? ', (distance,tasknumber,))
                con.commit()
                success = True
                status = 1
            
                if int(distance) > 20 :
                    cur2.execute('UPDATE ' + tasks_table + ' SET finishedbysensor = ?,unloadlatbysensor = ?,unloadlngbysensor = ? , unloadeddate = ? WHERE tasknumber = ? ', (True,lat,lng,datetime.now()+timedelta(hours=3),tasknumber,))
                    con.commit()
                    if abs(float(unloadlatbyuser) - float(lat)) > 0.2 or abs(float(unloadlngbyuser) - float(lng)) > 0.2:
                        # print(float(lat))
                        # print(float(unloadlatbyuser) )
                        # print(float(lng))
                        # print(float(unloadlngbyuser) )
                        cur2.execute('UPDATE ' + tasks_table + ' SET status = ? WHERE tasknumber = ? ', ("wrong",tasknumber,))
                        con.commit()
                    else:
                        cur2.execute('UPDATE ' + tasks_table + ' SET status = ? WHERE tasknumber = ? ', ("delivered",tasknumber,))
                        con.commit()



            


    cur2.close()
    con.close()        

    resp = jsonify(trackerid = trackerid , lat = lat , lng = lng , distance = distance , success = success , status = status)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*") 
    return resp

if __name__ == '__main__':
    app.run(debug=True,port=13000,use_reloader=False,host='0.0.0.0')


# @REM sudo kill -9 `sudo lsof -t -i:13000`
