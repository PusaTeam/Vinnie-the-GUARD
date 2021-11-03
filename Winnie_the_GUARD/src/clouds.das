require daslib/media

var cloud1_img: Image <- create_image("content/background/cloud1.png")
var cloud2_img: Image <- create_image("content/background/cloud2.png")

let size_cloud1 = int2(cloud1_img.width * 2, cloud1_img.height * 2)
let size_cloud2 = int2(cloud2_img.width * 3, cloud2_img.height * 3)


struct Cloud
    alive: bool
    passed: bool
    position: float2
    size: float2
    isBigCloud: bool
    velocity: float
    defColor  = 0xFFFFFF
    darkColor = 0xC0C0C0


var
    clouds: array<Cloud>
    randFloat: int4


def init_cloud(var c: Cloud)
    c.isBigCloud = random_float(randFloat) >= 0.5
    c.alive = true
    c.passed = false
    c.size = float2(c.isBigCloud ? size_cloud2 : size_cloud1)
    c.position.x = float(get_screen_width()) + c.size.x
    c.position.y = clamp(random_float(randFloat) * float(get_screen_height()), 0.0 + c.size.y, float(get_screen_height()) / 2.0)
    c.velocity = c.isBigCloud ? 4.0 : 2.0


def render_cloud(var c: Cloud)
    enable_alpha_blend()
    draw_image(c.isBigCloud ? cloud2_img : cloud1_img, int(c.position.x), int(c.position.y), 0xFFFFFFFF, c.isBigCloud ? size_cloud2 : size_cloud1)
    disable_alpha_blend()


def update_cloud(var c: Cloud)
    c.position.x -= c.velocity


def check_for_new_clouds()
    if length(clouds) == 0 || clouds[length(clouds) - 1].position.x < float(get_screen_width()) - float(get_screen_width()) * random_float(randFloat) * 23.0
        var c: Cloud
        init_cloud(c)
        push(clouds, c)


def remove_out_of_screen_clouds()
    let index = find_index_if(clouds) <| $(item)
        return item.position.x <= 0.0 - float(item.size.x)
    if index >= 0
        erase(clouds, index)




