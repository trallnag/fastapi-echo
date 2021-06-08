import json

from fastapi import FastAPI, Request, Response
from fastapi.encoders import jsonable_encoder

app = FastAPI()


@app.route("/health")
def health(request: Request) -> Response:
    return Response(status_code=200, content="OK")


async def echo(request: Request) -> Response:
    result = {
        "method": request.method,
        "url": str(request.url),
        "headers": jsonable_encoder(request.headers),
        "query_params": jsonable_encoder(request.query_params),
        "path_params": jsonable_encoder(request.path_params),
        "client": {
            "host": request.client.host,
            "port": request.client.port,
        },
        "cookies": request.cookies,
        "body": (await request.body()).decode("utf-8"),
    }
    return Response(status_code=200, content=json.dumps(result, indent=4))


app.add_route(
    path="/{full_path:path}",
    route=echo,
    methods=["GET", "POST", "PATCH", "DELETE"],
)
