import express, { response } from 'express';

const app = express();
app.use(express.json);

const users = []

app.post('/usuarios', (request, response) =>{
    console.log(request)

    response.send('Ok, deu certo')
})

app.get('/usuarios', (request, response) => {
    response.send('Ok')
})

app.listen(3000)

