import { DynamoDBClient, ScanCommand } from "@aws-sdk/client-dynamodb";

const client = new DynamoDBClient({ region: "us-east-1" });
const TABLE_NAME = process.env.TABLE_NAME;

export const handler = async () => {
  try {
    const data = await client.send(new ScanCommand({ TableName: TABLE_NAME }));

    const cursos = data.Items.map(item => ({
      id: item.id.S,
      nombre: item.nombre.S,
      profesor: item.profesor.S,
    }));

    return { statusCode: 200, body: JSON.stringify(cursos) };
  } catch (err) {
    return { statusCode: 500, body: JSON.stringify({ error: err.message }) };
  }
};
