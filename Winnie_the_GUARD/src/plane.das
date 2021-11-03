require daslib/media

var plane_img: Image <- create_image("content/plane/plane.png")
var bomber_img: Image <- create_image("content/plane/bomber.png")
var blitz_img: Image <- create_image("content/plane/blitz.png")


struct Plane
    position: float2
    velocity: float2
    width: int
    height: int
    alive: bool
    render: Image
    vertical_speed: float
    horisontal_speed: float


def reset_plane(var p: Plane)
    p.width = 70
    p.height = 150
    p.position = float2(float(p.width), float(get_screen_height() / 2))
    p.alive = true


def kill_plane(var p: Plane)
    p.alive = false
    p.velocity.x = 0.0


def update_plane(var p: Plane)
    if p.position.y <= 0.0
        p.position.y = 0.0
    if p.position.y >= float(get_screen_height() - p.height / 2)
        p.position.y = float(get_screen_height() - p.height / 2)
    if p.position.x < float(p.width)
        p.position.x = float(p.width)
    if p.position.x >= float(get_screen_width())
        p.position.x = float(get_screen_width())


def render_plane(var p: Plane; var curWeap: string)
    p.width = 150
    p.height = 200
    let x = int(p.position.x - float(p.width))
    let y = int(p.position.y - float(p.height) * 0.5)
    let plane_size = int2(p.width, p.height)
    p.vertical_speed = float(get_screen_height()) / 100.0
    p.horisontal_speed = float(get_screen_width()) / 175.0
    if curWeap == "BAZOOK"
        enable_alpha_blend()
        draw_image(bomber_img, x, y, 0xFFFFFFFF, plane_size)
        disable_alpha_blend()
    elif curWeap == "MGUN"
        enable_alpha_blend()
        draw_image(blitz_img, x, y, 0xFFFFFFFF, plane_size)
        disable_alpha_blend()
    else
        enable_alpha_blend()
        draw_image(plane_img, x, y, 0xFFFFFFFF, plane_size)
        disable_alpha_blend()


def vert_movement_plane(var p: Plane; var direction: float)
    if p.alive
        p.position.y += p.vertical_speed * direction

def hor_movement_plane(var p: Plane; var direction: float)
    if p.alive
        p.position.x += p.horisontal_speed * direction


