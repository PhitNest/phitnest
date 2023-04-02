echo "<gql>" > /usr/local/schema.gql
sleep 60
curl -X POST -H "Content-Type: application/graphql" --data-binary '@/usr/local/schema.gql' http://localhost:8080/admin/schema