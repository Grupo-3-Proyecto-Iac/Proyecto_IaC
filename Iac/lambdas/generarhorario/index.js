/**
Angelo Sosa
 */
import { DynamoDBClient, UpdateItemCommand } from "@aws-sdk/client-dynamodb";
import { marshall } from "@aws-sdk/util-dynamodb";
import { randomUUID } from "crypto";

const client = new DynamoDBClient({ region: "us-east-1" });
const TABLE_NAME = process.env.USER_PROFILE_TABLE;

export const handler = async (event) => {
  const { userId } = event.pathParameters;
  const body = JSON.parse(event.body || "{}");

  if (!body.nombre || !Array.isArray(body.cursos) || body.cursos.length === 0) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: "El 'nombre' del horario y una lista de 'cursos' son requeridos." }),
    };
  }

  const nuevoHorario = {
    horarioId: randomUUID(),
    nombre: body.nombre,
    cursos: body.cursos, 
    creadoEn: new Date().toISOString(),
  };

  const command = new UpdateItemCommand({
    TableName: TABLE_NAME,
    Key: marshall({ userId }),
    UpdateExpression: "SET horarios = list_append(horarios, :nuevoHorario)",
    ExpressionAttributeValues: {
      ":nuevoHorario": { L: [marshall(nuevoHorario)] },
    },
    ReturnValues: "UPDATED_NEW",
  });

  try {
    const result = await client.send(command);
    return {
      statusCode: 201, 
      body: JSON.stringify({
        message: "Horario generado y agregado exitosamente.",
        horarios: result.Attributes.horarios.L,
      }),
    };
  } catch (error) {
    console.error("Error adding schedule:", JSON.stringify(error, null, 2));
    if (error.name === 'ConditionalCheckFailedException') {
        return { statusCode: 404, body: JSON.stringify({ message: "Usuario no encontrado." }) };
    }
    return { statusCode: 500, body: JSON.stringify({ message: "Error interno al generar el horario." }) };
  }
};