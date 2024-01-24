# init.sh
mongosh << EOF

use user;


// crea il database
db = db.getSiblingDB('databaseName');

// crea un nuovo utente che ha i permessi sul database
db.createUser(
    {
        user: "user1",
        pwd: "user1",
        roles: [
            {
                role: "readWrite",
                db: "databaseName"
            }
        ]
    }
);



// crea una collection
db.createCollection('prodotti');



db.prodotti.insertOne(
  {
    "id":1,
    "marca":"fiat"
  }
);


EOF
