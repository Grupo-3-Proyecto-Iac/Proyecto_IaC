import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb";

const client = new DynamoDBClient({ region: "us-east-1" });
const TABLE_NAME = process.env.TABLE_NAME;

export const handler = async (event) => {
  try {
    const body = JSON.parse(event.body);
    const { id, nombre, profesor } = body;

    if (!id || !nombre || !profesor) {
      return {
        statusCode: 400,
        body: JSON.stringify({ message: "Faltan campos obligatorios." }),
      };
    }

    await client.send(new PutItemCommand({
      TableName: TABLE_NAME,
      Item: {
        id: { S: id },
        nombre: { S: nombre },
        profesor: { S: profesor },
      },
    }));

    return {
      statusCode: 201,
      body: JSON.stringify({ message: "Curso creado correctamente." }),
    };
  } catch (err) {
    return { statusCode: 500, body: JSON.stringify({ error: err.message }) };
  }
};
