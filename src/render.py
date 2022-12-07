import jinja_render as jr
import typer

app = typer.Typer()

default_report = "cat_population_estimation"


@app.command()
def write_dot_tex(report_name: str = typer.Argument(default_report)):
    jr.write_tex(report_name)


if __name__ == "__main__":
    app()
