// Base de datos: chinook
// Ejecutar cada consulta por separado en MongoDB Playground

use('chinook');

// 2.1 INSERTAR UN NUEVO GÉNERO MUSICAL
// Insertar género "Synthwave" con GenreId 26
db.Genre.insertOne({
    GenreId: 26,
    Name: "Synthwave"
});

// Verificar inserción
db.Genre.find({ Name: "Synthwave" });

// 2.2 CONSULTAR GÉNEROS CON "ROCK" EN EL NOMBRE
db.Genre.find({
    Name: { $regex: /Rock/i }
});

// Con proyección (solo nombres)
db.Genre.find(
    { Name: { $regex: /Rock/i } },
    { Name: 1, _id: 0 }
);


// 2.3 BUSCAR FACTURAS CON TOTAL MAYOR A 10 DÓLARES
db.Invoice.find({
    Total: { $gt: 10 }
});

// Ordenado por total descendente
db.Invoice.find({
    Total: { $gt: 10 }
}).sort({ Total: -1 });

// Con proyección
db.Invoice.find(
    { Total: { $gt: 10 } },
    { 
        InvoiceId: 1, 
        CustomerId: 1, 
        InvoiceDate: 1, 
        Total: 1,
        _id: 0 
    }
).sort({ Total: -1 });

// Contar resultados
db.Invoice.countDocuments({
    Total: { $gt: 10 }
});


// 2.4 OBTENER NOMBRE Y APELLIDO DE TODOS LOS EMPLEADOS
db.Employee.find(
    {},
    { 
        FirstName: 1, 
        LastName: 1, 
        _id: 0 
    }
);

// Con nombre completo concatenado
db.Employee.aggregate([
    {
        $project: {
            _id: 0,
            NombreCompleto: { 
                $concat: ["$FirstName", " ", "$LastName"] 
            }
        }
    }
]);


// 2.5 ACTUALIZAR EMAILS DE EMPLEADOS
// Actualizar empleado con EmployeeId 3
db.Employee.updateOne(
    { EmployeeId: 3 },
    { $set: { Email: "estudiante1@duocuc.cl" } }
);

// Actualizar empleado con EmployeeId 5
db.Employee.updateOne(
    { EmployeeId: 5 },
    { $set: { Email: "estudiante2@duocuc.cl" } }
);

// Actualizar empleado con EmployeeId 7
db.Employee.updateOne(
    { EmployeeId: 7 },
    { $set: { Email: "estudiante3@duocuc.cl" } }
);

// Verificar actualizaciones
db.Employee.find(
    { EmployeeId: { $in: [3, 5, 7] } },
    { FirstName: 1, LastName: 1, Email: 1, _id: 0 }
);


// 2.6 INCREMENTAR PRECIO DE CANCIONES DE ROCK
// Ver estadísticas antes
db.Track.aggregate([
    { $match: { GenreId: 1 } },
    { 
        $group: {
            _id: null,
            count: { $sum: 1 },
            avgPrice: { $avg: "$UnitPrice" },
            minPrice: { $min: "$UnitPrice" },
            maxPrice: { $max: "$UnitPrice" }
        }
    }
]);

// Incrementar precio en 0.50
db.Track.updateMany(
    { GenreId: 1 },
    { $inc: { UnitPrice: 0.50 } }
);

// Verificar algunas canciones
db.Track.find(
    { GenreId: 1 },
    { Name: 1, UnitPrice: 1, _id: 0 }
).limit(5);


// 2.7 CONSULTAR FACTURAS DE CANADÁ CON TOTAL > 5
db.Invoice.find({
    BillingCountry: "Canada",
    Total: { $gt: 5 }
});

// Con ordenamiento y proyección
db.Invoice.find(
    {
        BillingCountry: "Canada",
        Total: { $gt: 5 }
    },
    {
        InvoiceId: 1,
        InvoiceDate: 1,
        BillingCity: 1,
        Total: 1,
        _id: 0
    }
).sort({ Total: -1 });

// Estadísticas por ciudad
db.Invoice.aggregate([
    {
        $match: {
            BillingCountry: "Canada",
            Total: { $gt: 5 }
        }
    },
    {
        $group: {
            _id: "$BillingCity",
            totalFacturas: { $sum: 1 },
            montoTotal: { $sum: "$Total" },
            montoPromedio: { $avg: "$Total" }
        }
    },
    { $sort: { montoTotal: -1 } }
]);

// Contar resultados
db.Invoice.countDocuments({
    BillingCountry: "Canada",
    Total: { $gt: 5 }
});


// 2.8 ELIMINAR GÉNERO MUSICAL CREADO
// Verificar antes de eliminar
db.Genre.find({ Name: "Synthwave" });

// Eliminar género
db.Genre.deleteOne({
    Name: "Synthwave"
});

// Verificar eliminación
db.Genre.find({ Name: "Synthwave" });


// 2.9 ELIMINAR FACTURAS ANTERIORES A 2010
// IMPORTANTE: Verificar cuántas se eliminarán primero
db.Invoice.countDocuments({
    InvoiceDate: { $lt: "2010-01-01 00:00:00" }
});

// Ver algunas facturas que se eliminarán
db.Invoice.find({
    InvoiceDate: { $lt: "2010-01-01 00:00:00" }
}).limit(5);

// Ver rango de fechas
db.Invoice.aggregate([
    {
        $group: {
            _id: null,
            minDate: { $min: "$InvoiceDate" },
            maxDate: { $max: "$InvoiceDate" },
            total: { $sum: 1 }
        }
    }
]);

// ELIMINAR
// db.Invoice.deleteMany({
//     InvoiceDate: { $lt: "2010-01-01 00:00:00" }
// });

// Verificar después de eliminar
// db.Invoice.countDocuments({
//     InvoiceDate: { $lt: "2010-01-01 00:00:00" }
// });


// 2.10 ENCONTRAR FACTURAS DE CLIENTES ESPECÍFICOS
// Buscar facturas de clientes con CustomerId 1, 5, 10, 15, 20
db.Invoice.find({
    CustomerId: { $in: [1, 5, 10, 15, 20] }
});

// Con proyección y ordenamiento
db.Invoice.find(
    { CustomerId: { $in: [1, 5, 10, 15, 20] } },
    {
        InvoiceId: 1,
        CustomerId: 1,
        InvoiceDate: 1,
        Total: 1,
        _id: 0
    }
).sort({ CustomerId: 1, InvoiceDate: -1 });

// Con información del cliente
db.Invoice.aggregate([
    {
        $match: {
            CustomerId: { $in: [1, 5, 10, 15, 20] }
        }
    },
    {
        $lookup: {
            from: "Customer",
            localField: "CustomerId",
            foreignField: "CustomerId",
            as: "clienteInfo"
        }
    },
    {
        $unwind: "$clienteInfo"
    },
    {
        $project: {
            _id: 0,
            InvoiceId: 1,
            CustomerId: 1,
            ClienteNombre: {
                $concat: [
                    "$clienteInfo.FirstName",
                    " ",
                    "$clienteInfo.LastName"
                ]
            },
            InvoiceDate: 1,
            Total: 1
        }
    },
    {
        $sort: { CustomerId: 1, InvoiceDate: -1 }
    }
]);

// Estadísticas por cliente
db.Invoice.aggregate([
    {
        $match: {
            CustomerId: { $in: [1, 5, 10, 15, 20] }
        }
    },
    {
        $group: {
            _id: "$CustomerId",
            totalFacturas: { $sum: 1 },
            montoTotal: { $sum: "$Total" },
            facturaPromedio: { $avg: "$Total" }
        }
    },
    {
        $sort: { montoTotal: -1 }
    }
]);


// 2.11 INSERTAR NUEVA FACTURA
// Obtener el próximo InvoiceId
db.Invoice.find().sort({InvoiceId: -1}).limit(1);

// Obtener información del cliente 15
db.Customer.findOne({ CustomerId: 15 });

// Insertar nueva factura (usar InvoiceId siguiente al máximo)
// Ejemplo: si el máximo es 412, usar 413
db.Invoice.insertOne({
    InvoiceId: 413,
    CustomerId: 15,
    InvoiceDate: "2013-01-10 00:00:00",
    BillingAddress: "700 W Pender Street",
    BillingCity: "Vancouver",
    BillingState: "BC",
    BillingCountry: "Canada",
    BillingPostalCode: "V6C 1G8",
    Total: 25.75
});

// Verificar inserción
db.Invoice.findOne({ InvoiceId: 413 });


// 2.12 ACTUALIZAR DATOS DE EMPLEADO
// Ver estado previo
db.Employee.findOne(
    { EmployeeId: 4 },
    { FirstName: 1, LastName: 1, Phone: 1, Title: 1, _id: 0 }
);

// Actualizar empleado
db.Employee.updateOne(
    { EmployeeId: 4 },
    {
        $set: {
            Phone: "+56 09 98765-4321",
            Title: "Senior Sales Support Agent"
        }
    }
);

// Verificar actualización
db.Employee.findOne(
    { EmployeeId: 4 },
    { FirstName: 1, LastName: 1, Phone: 1, Title: 1, _id: 0 }
);


// 2.13 BUSCAR CANCIONES DE ROCK O METAL CON PRECIO ≤ 1
// Rock tiene GenreId: 1, Metal tiene GenreId: 3
db.Track.find({
    GenreId: { $in: [1, 3] },
    UnitPrice: { $lte: 1.00 }
});

// Con proyección
db.Track.find(
    {
        GenreId: { $in: [1, 3] },
        UnitPrice: { $lte: 1.00 }
    },
    {
        Name: 1,
        Composer: 1,
        UnitPrice: 1,
        GenreId: 1,
        _id: 0
    }
).sort({ UnitPrice: 1 });

// Con nombre del género
db.Track.aggregate([
    {
        $match: {
            GenreId: { $in: [1, 3] },
            UnitPrice: { $lte: 1.00 }
        }
    },
    {
        $lookup: {
            from: "Genre",
            localField: "GenreId",
            foreignField: "GenreId",
            as: "genreInfo"
        }
    },
    {
        $unwind: "$genreInfo"
    },
    {
        $project: {
            _id: 0,
            TrackName: "$Name",
            Composer: 1,
            Genre: "$genreInfo.Name",
            Price: "$UnitPrice",
            Duration: "$Milliseconds"
        }
    },
    {
        $sort: { Price: 1, Genre: 1 }
    }
]);

// Estadísticas
db.Track.aggregate([
    {
        $match: {
            GenreId: { $in: [1, 3] },
            UnitPrice: { $lte: 1.00 }
        }
    },
    {
        $group: {
            _id: "$GenreId",
            totalCanciones: { $sum: 1 },
            precioPromedio: { $avg: "$UnitPrice" },
            precioMin: { $min: "$UnitPrice" },
            precioMax: { $max: "$UnitPrice" }
        }
    }
]);

// Contar resultados
db.Track.countDocuments({
    GenreId: { $in: [1, 3] },
    UnitPrice: { $lte: 1.00 }
});


// 2.14 REEMPLAZAR INFORMACIÓN DE MEDIATYPE
// Ver estado previo
db.MediaType.findOne({ MediaTypeId: 1 });

// Actualizar MediaType
db.MediaType.updateOne(
    { MediaTypeId: 1 },
    { $set: { Name: "High-Quality MPEG audio file" } }
);

// Verificar actualización
db.MediaType.findOne({ MediaTypeId: 1 });

// Ver todos los MediaTypes
db.MediaType.find().sort({ MediaTypeId: 1 });


// 2.15 OBTENER TOP 5 FACTURAS POR MONTO
db.Invoice.find(
    {},
    { 
        CustomerId: 1,
        Total: 1,
        _id: 0 
    }
).sort({ Total: -1 }).limit(5);

// Con información del cliente
db.Invoice.aggregate([
    {
        $sort: { Total: -1 }
    },
    {
        $limit: 5
    },
    {
        $lookup: {
            from: "Customer",
            localField: "CustomerId",
            foreignField: "CustomerId",
            as: "customerInfo"
        }
    },
    {
        $unwind: "$customerInfo"
    },
    {
        $project: {
            _id: 0,
            CustomerId: 1,
            ClienteNombre: {
                $concat: [
                    "$customerInfo.FirstName",
                    " ",
                    "$customerInfo.LastName"
                ]
            },
            Pais: "$customerInfo.Country",
            Total: 1,
            InvoiceDate: 1
        }
    }
]);


// 2.16 ELIMINAR CANCIONES DE METAL CORTAS
// Metal tiene GenreId: 3, 3 minutos = 180,000 milliseconds
// IMPORTANTE: Verificar antes de eliminar

// Contar canciones que se eliminarán
db.Track.countDocuments({
    GenreId: 3,
    Milliseconds: { $lt: 180000 }
});

// Ver algunas canciones que se eliminarán
db.Track.find(
    {
        GenreId: 3,
        Milliseconds: { $lt: 180000 }
    },
    {
        Name: 1,
        Milliseconds: 1,
        Composer: 1,
        _id: 0
    }
).limit(10);

// Estadísticas de canciones Metal
db.Track.aggregate([
    {
        $match: { GenreId: 3 }
    },
    {
        $group: {
            _id: null,
            total: { $sum: 1 },
            avgDuration: { $avg: "$Milliseconds" },
            minDuration: { $min: "$Milliseconds" },
            maxDuration: { $max: "$Milliseconds" }
        }
    }
]);

// ELIMINAR
// db.Track.deleteMany({
//     GenreId: 3,
//     Milliseconds: { $lt: 180000 }
// });

// Verificar después de eliminar
// db.Track.countDocuments({
//     GenreId: 3,
//     Milliseconds: { $lt: 180000 }
// });


// 2.17 CONTAR FACTURAS DE CANADÁ
db.Invoice.countDocuments({
    BillingCountry: "Canada"
});

// Estadísticas por ciudad
db.Invoice.aggregate([
    {
        $match: {
            BillingCountry: "Canada"
        }
    },
    {
        $group: {
            _id: "$BillingCity",
            totalFacturas: { $sum: 1 },
            montoTotal: { $sum: "$Total" },
            montoPromedio: { $avg: "$Total" }
        }
    },
    {
        $sort: { totalFacturas: -1 }
    }
]);

// Estadísticas completas
db.Invoice.aggregate([
    {
        $match: {
            BillingCountry: "Canada"
        }
    },
    {
        $group: {
            _id: null,
            primeraFactura: { $min: "$InvoiceDate" },
            ultimaFactura: { $max: "$InvoiceDate" },
            totalFacturas: { $sum: 1 },
            montoTotal: { $sum: "$Total" }
        }
    }
]);


// 2.18 AGREGAR CAMPO "TAGS" A EMPLEADOS
// Ver empleados que serán actualizados
db.Employee.find(
    { Title: "Sales Support Agent" },
    { FirstName: 1, LastName: 1, Title: 1, _id: 0 }
);

// Agregar campo tags
db.Employee.updateMany(
    { Title: "Sales Support Agent" },
    { 
        $set: { 
            tags: "Servicio al Cliente"
        }
    }
);

// Verificar actualización
db.Employee.find(
    { Title: "Sales Support Agent" },
    { 
        FirstName: 1, 
        LastName: 1, 
        Title: 1, 
        tags: 1,
        _id: 0 
    }
);

// Con tags como array
// db.Employee.updateMany(
//     { Title: "Sales Support Agent" },
//     { 
//         $set: { 
//             tags: ["Servicio al Cliente", "Ventas", "Soporte"]
//         }
//     }
// );


// CONSULTAS ADICIONALES DE VERIFICACIÓN

// Verificar total de documentos por colección
db.Genre.countDocuments();
db.Artist.countDocuments();
db.Album.countDocuments();
db.Track.countDocuments();
db.Customer.countDocuments();
db.Employee.countDocuments();
db.Invoice.countDocuments();
db.InvoiceLine.countDocuments();
db.MediaType.countDocuments();
db.Playlist.countDocuments();
db.PlaylistTrack.countDocuments();

// Ver estructura de un documento de ejemplo
db.Genre.findOne();
db.Artist.findOne();
db.Track.findOne();
db.Invoice.findOne();

