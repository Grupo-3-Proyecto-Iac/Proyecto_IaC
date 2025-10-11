import { DynamoDBClient, DeleteItemCommand } from "@aws-sdk/client-dynamodb";

const client = new DynamoDBClient({ region: "us-east-1" });
const TABLE_NAME = process.env.TABLE_NAME;

export const handler = async (event) => {
  try {
    const { id } = event.pathParameters || {};

    if (!id) {
      return { statusCode: 400, body: JSON.stringify({ message: "Falta el ID del curso." }) };
    }

    await client.send(new DeleteItemCommand({
      TableName: TABLE_NAME,
      Key: { id: { S: id } },
    }));

    return { statusCode: 200, body: JSON.stringify({ message: `Curso ${id} eliminado.` }) };
  } catch (err) {
    return { statusCode: 500, body: JSON.stringify({ error: err.message }) };
  }
};
