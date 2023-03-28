echo "<gql>" > /usr/local/schema.gql
curl -X POST -H "Content-Type: application/graphql" --data-binary '@/usr/local/schema.gql' http://localhost:8080/admin/schema