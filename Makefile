pgName = gin_postgresql
pgadName = pgadmin_container
runPg:
	docker run -d   --name $(pgName)   -e POSTGRES_USER=admin   -e POSTGRES_PASSWORD=123   -e POSTGRES_DB=gin_api   -p 5432:5432   postgres
runPgad:
	docker run -d   --name $(pgadName)   -e PGADMIN_DEFAULT_EMAIL=admin@gmail.com   -e PGADMIN_DEFAULT_PASSWORD=123   -p 8080:80   dpage/pgadmin4
startPg:
	docker start $(pgName)
startPgad:
	docker start $(pgadName)
createdb:
	docker exec -it $(pgName) createdb --username=admin --owner=admin gin_api
dropdb:
	docker exec -it $(pgName) dropdb --username=admin gin_api
migrateUp:
	migrate -path db/migrations -database "postgresql://admin:123@localhost:5432/gin_api?sslmode=disable" -verbose up

migrateDown:
	migrate -path db/migrations -database "postgresql://admin:123@localhost:5432/gin_api?sslmode=disable" -verbose down

.PHONY: createdb dropdb runPg runPgad startPgad startPg m