import sql from 'mssql'

const configuracionBD = {
    user: 'sa', 
    password: '%=8585FF0506%',
    server: 'localhost',
    database: 'Fragmento1AW',
    options: {
        encrypt: true,
        trustServerCertificate: true,
    }
}

export async function ConexionBDD() {
    try {
        const conexion = await sql.connect(configuracionBD);
        return conexion;
    } catch (error) {
        console.error(error);
    }
} 