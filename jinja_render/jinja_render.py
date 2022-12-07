import os
import json
from jinja2 import Environment, FileSystemLoader


def write_tex(report_name: str, summary_path="tests/data/results.json"):
    rendered_report = get_rendered_report(report_name, summary_path)
    with open(f"reports/{report_name}.tex", "w") as report_tex:
        report_tex.writelines(rendered_report)


def load_json(path):
    with open(path, encoding="utf8") as info_file:
        information = json.load(info_file)
    return information


def get_jinja_latex():
    latex_jinja_env = Environment(
        variable_start_string="\VAR{",
        variable_end_string="}",
        comment_start_string="\#{",
        comment_end_string="}",
        trim_blocks=True,
        loader=FileSystemLoader(os.path.abspath(".")),
    )
    return latex_jinja_env


def get_rendered_report(report_name, path):
    effort_summary = load_json(path)
    latex_jinja_env = get_jinja_latex()
    template = latex_jinja_env.get_template(f"reports/templates/{report_name}.tex")
    return template.render(effort_summary)
