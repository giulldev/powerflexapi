import express from 'express';
import sql from 'mssql';

const app = express();
app.use(express.json());

const port = 4000;

// Configuração do SQL Server
const dbConfig = {
    user: 'seu_usuario',
    password: 'sua_senha',
    server: 'localhost', // Altere se necessário
    database: 'powerflexdb',
    port: 1433,
    options: {
        encrypt: true, // Para conexões seguras
        enableArithAbort: true
    }
};

// Conexão com o banco de dados
let pool;
sql.connect(dbConfig)
    .then((connection) => {
        pool = connection;
        console.log('Conectado ao banco de dados SQL Server');
    })
    .catch((err) => console.error('Erro na conexão com o banco de dados:', err));

// Endpoints
app.post('/usuarios', async (req, res) => {
    const { nome, cpf, email, password, cod_status } = req.body;
    try {
        const result = await pool.request()
            .input('nome', sql.VarChar(100), nome)
            .input('cpf', sql.VarChar(100), cpf)
            .input('email', sql.VarChar(45), email)
            .input('password', sql.VarChar(250), password)
            .input('cod_status', sql.Bit, cod_status)
            .query(`
                INSERT INTO usuarios (nome, cpf, email, password, cod_status)
                VALUES (@nome, @cpf, @email, @password, @cod_status);
                SELECT SCOPE_IDENTITY() AS id;
            `);
        res.status(201).json({ id: result.recordset[0].id, message: 'Usuário criado com sucesso' });
    } catch (err) {
        res.status(500).json({ error: 'Erro ao criar usuário', details: err.message });
    }
});

app.get('/usuarios', async (req, res) => {
    try {
        const result = await pool.request().query('SELECT * FROM usuarios');
        res.status(200).json(result.recordset);
    } catch (err) {
        res.status(500).json({ error: 'Erro ao buscar usuários', details: err.message });
    }
});

app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);
});
