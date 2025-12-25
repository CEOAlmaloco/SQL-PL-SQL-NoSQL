const { MongoClient } = require('mongodb');
const fs = require('fs');
const path = require('path');

const uri = 'mongodb://localhost:27017';
const dbName = 'chinook';

const collections = [
    { name: 'Genre', file: 'Genre.json' },
    { name: 'Artist', file: 'Artist.json' },
    { name: 'Album', file: 'Album.json' },
    { name: 'Track', file: 'Track.json' },
    { name: 'Customer', file: 'Customer.json' },
    { name: 'Employee', file: 'Employee.json' },
    { name: 'Invoice', file: 'Invoice.json' },
    { name: 'InvoiceLine', file: 'InvoiceLine.json' },
    { name: 'MediaType', file: 'MediaType.json' },
    { name: 'Playlist', file: 'Playlist.json' },
    { name: 'PlaylistTrack', file: 'PlaylistTrack.json' }
];

async function importData() {
    const client = new MongoClient(uri);
    
    try {
        await client.connect();
        console.log('Conectado a MongoDB');
        
        const db = client.db(dbName);
        
        for (const collection of collections) {
            const filePath = path.join(__dirname, collection.file);
            
            if (!fs.existsSync(filePath)) {
                console.log(`Archivo no encontrado: ${collection.file}`);
                continue;
            }
            
            const fileContent = fs.readFileSync(filePath, 'utf8');
            const documents = JSON.parse(fileContent);
            
            await db.collection(collection.name).deleteMany({});
            
            if (documents.length > 0) {
                const result = await db.collection(collection.name).insertMany(documents);
                console.log(`${collection.name}: ${result.insertedCount} documentos`);
            } else {
                console.log(`${collection.name}: archivo vacío`);
            }
        }
        
        console.log('\nVerificación de datos:');
        for (const collection of collections) {
            const count = await db.collection(collection.name).countDocuments();
            console.log(`   ${collection.name}: ${count} documentos`);
        }
        
        console.log('\nImportación completada!');
        
    } catch (error) {
        console.error('Error:', error.message);
    } finally {
        await client.close();
    }
}

importData();

