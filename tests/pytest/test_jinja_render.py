import hashlib
import os

from jinja_render import (
    get_rendered_report,
    write_tex,
)


expected_hash = "d074b337bb232717f0f2858dbcb1b3d9"
report_name = "cat_population_estimation"
summary_path = "tests/data/results.json"


def test_write_rendered_report():
    tex_path = "reports/cat_population_estimation.tex"
    if os.path.exists(tex_path):
        os.remove(tex_path)
    write_tex(report_name, summary_path)
    assert os.path.exists(tex_path)


def test_rendered_report():
    obtained_hash = _get_hash_from_tex_file()
    assert (
        obtained_hash == expected_hash
    ), "El hash del archivo reports/cat_population_estimation.tex"


def _get_hash_from_tex_file():
    rendered_report = get_rendered_report(report_name, summary_path)
    report_content = rendered_report.encode("utf-8")
    obtained_hash = hashlib.md5(report_content).hexdigest()
    return obtained_hash


