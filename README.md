# Messenger-DataBase

<h4> Mohammad hosein Shabaniraad - Mohammad reza Abedin </h4>
<h6> K.N. Toosi University DataBase Course Project Fall 2024 </h6>

--------
Find all Er models in ER Models directories

[PDF](./ER%20Models/Phase1%20DB.drawio.pdf)

[Drawio](./ER%20Models/Phase1%20DB.drawio)

ALL CRUD Query in creates.sql

[CRUD codes](./creates.sql)

Some Query for getting data in Query directory

[Queries](./Query)

### Run load test app

in our scenario we add random fake human user
with python code
[Load-tester](./Load%20test/load_test.py)

```
python load_test.py 
```

you can see result of what data added in web-app

### Run nodejs web app

<ul>
<li>
install all modules you need with : 

```
npm install 
```

</li>

<li>
run app from terminal:

```
node server.js
```

note : setup .env vars to connect yourDB
</li>

<li>
see all tables data in :

```
localhost:3000/
```

</li>

<li>
sign up in :

```
localhost:3000/signup.html
```

</li>

<li>
chat in :

```
localhost:3000/chat.html
```

</li>

</ul>