export async function invoke(event) {
  return {
    statusCode: 200,
    body: JSON.stringify(event),
  };
}
