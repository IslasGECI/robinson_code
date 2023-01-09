import jinja_render as jr
import typer

app = typer.Typer()

default_report = "cat_population_estimation"
summary_path = "tests/data/results.json"


@app.command()
def write_dot_tex(
    report_name: str = typer.Argument(default_report),
    summary_path: str = typer.Argument(summary_path),
):
    jr.write_tex(report_name, summary_path)


if __name__ == "__main__":
    app()
