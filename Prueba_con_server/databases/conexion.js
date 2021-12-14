import sql from 'mssql'

const configuracionBD = {
    user: process.env.USER, 
    password: process.env.PASSWORD,
    server: process.env.SERVER,
    database: process.env.DB,
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
        console.log(error)
    }
} 