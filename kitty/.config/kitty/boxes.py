def main(args):
    pass


from functools import partial as p

from kittens.tui.handler import result_handler
from kitty.fonts.box_drawing import (
    BufType,
    ParameterizedFunc,
    SSByteArray,
    box_chars,
    fill_region,
    hline,
    rectircle_equations,
    supersampled,
    thickness,
    vline,
)

# example box: echo $'\u2800\u2806\u2801\n\u2805 \u2804\n\u2802\u2807\u2803'


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    """Inserts filled rounded corner box drawing characters."""
    box_chars["⠀"] = [p(rounded_corner, which="╭", fill_right=True)]  # u2800 - top left
    box_chars["⠁"] = [p(rounded_corner, which="╮", fill_left=True)]  # u2801 - top right
    box_chars["⠂"] = [
        p(rounded_corner, which="╰", fill_right=True)
    ]  # u2802 - bottom left
    box_chars["⠃"] = [
        p(rounded_corner, which="╯", fill_left=True)
    ]  # u2803 - bottom right
    box_chars["⠄"] = [p(vline_filled, fill_left=True)]  # u2804 - vert left
    box_chars["⠅"] = [p(vline_filled, fill_right=True)]  # u2805 - vert right
    box_chars["⠆"] = [p(hline_filled, fill_top=True)]  # u2806 - horz top
    box_chars["⠇"] = [p(hline_filled, fill_bottom=True)]  # u2807 - horz bottom


def vline_filled(
    buf: BufType,
    width: int,
    height: int,
    level: int = 1,
    fill_left: bool = False,
    fill_right: bool = False,
):
    if fill_left:
        xlimits = [(0, height) for _ in range(0, width // 2)]
    elif fill_right:
        xlimits = [(-1, -1) if x < width // 2 else (0, height) for x in range(0, width)]
    else:
        xlimits = []
    fill_region(buf, width, height, xlimits)
    vline(buf, width, height, level)


def hline_filled(
    buf: BufType,
    width: int,
    height: int,
    level: int = 1,
    fill_top: bool = False,
    fill_bottom: bool = False,
):
    if fill_top:
        xlimits = [(height // 2, height) for _ in range(0, width)]
    elif fill_bottom:
        xlimits = [(0, height // 2) for _ in range(0, width)]
    else:
        xlimits = []
    fill_region(buf, width, height, xlimits)
    hline(buf, width, height, level)


@supersampled()
def rounded_corner(
    buf: SSByteArray,
    width: int,
    height: int,
    level: int = 1,
    which: str = "╭",
    fill_right: bool = False,
    fill_left: bool = False,
) -> None:
    """Modified from https://github.com/kovidgoyal/kitty/blob/master/kitty/fonts/box_drawing.py#L490"""
    xfunc, yfunc = rectircle_equations(width, height, buf.supersample_factor, which)
    draw_parametrized_curve(
        buf, width, height, level, xfunc, yfunc, fill_right, fill_left
    )


def draw_parametrized_curve(
    buf: SSByteArray,
    width: int,
    height: int,
    level: int,
    xfunc: ParameterizedFunc,
    yfunc: ParameterizedFunc,
    fill_right: bool = False,
    fill_left: bool = False,
) -> None:
    """Modified from https://github.com/kovidgoyal/kitty/blob/master/kitty/fonts/box_drawing.py#L412"""
    supersample_factor = buf.supersample_factor
    num_samples = height * 8
    delta, extra = divmod(thickness(level), 2)
    delta *= supersample_factor
    extra *= supersample_factor
    seen = set()
    for i in range(num_samples + 1):
        t = i / num_samples
        p = int(xfunc(t)), int(yfunc(t))
        if p in seen:
            continue
        x_p, y_p = p
        seen.add(p)
        for y in range(y_p - delta, y_p + delta + extra):
            if 0 <= y < height:
                offset = y * width
                x_start = x_p - delta
                if fill_left:
                    x_start = 0
                x_end = x_p + delta + extra
                if fill_right:
                    x_end = width
                for x in range(x_start, x_end):
                    if 0 <= x < width:
                        pos = offset + x
                        buf[pos] = min(255, buf[pos] + 255)
