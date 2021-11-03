require daslib/media

var
    def_bullet_img: Image <- create_image("content/plane/ammo/default.png")
    blitz_img: Image <- create_image("content/plane/ammo/blitz.png")
    bomb_img : Image <- create_image("content/plane/ammo/bomb.png")

let
    size_default = int2(60, 40)
    size_blitz = int2(100, 40)
    size_bomb = int2(45, 60)

struct Bullet
    damage: float
    position: float2
    vel: float2
    size: int2
    color: uint
    ttf: float


var weapons <- {{
    "Pistol" => [[ Bullet
        damage = 1.0,
        ttf = 0.15,
        vel = float2(15.0, 0.0),
        size = size_default,
        color = 0xFFAA0000
    ]];
    "MGUN" => [[ Bullet
        damage = 0.3,
        ttf = 0.05,
        vel = float2(20.0, 0.0),
        size = size_blitz,
        color = 0xAAFCDC26
    ]];
    "BAZOOK" => [[ Bullet
        damage = 10.0,
        ttf = 1.1,
        vel = float2(0.0, 10.0),
        size = size_bomb,
        color = 0xAA000000
    ]]
}}

var
    bullets: array<Bullet>
    weaponsArr = [[string
                    "Pistol";
                    "MGUN";
                    "BAZOOK"
                ]]



def bullet_update(var b: Bullet)
    b.position.x += b.vel.x
    b.position.y += b.vel.y


def bullet_render(var b: Bullet; var curWeap: string)
    let p1 = b.position.x + b.vel.x
    if(curWeap == "BAZOOK" )
        enable_alpha_blend()
        draw_image(bomb_img, int(p1), int(b.position.y), 0xFFFFFFFF, b.size)
        disable_alpha_blend()
    else
        enable_alpha_blend()
        draw_image(curWeap == "Pistol" ? def_bullet_img : blitz_img,
        int(p1), int(b.position.y), b.color, b.size)
        disable_alpha_blend()


def add_bullet(position: float2; var weapon: string)
    var b: Bullet = weapons[weapon]
    if(weapon == "BAZOOK")
        b.position.x = position.x - 40.0
        b.position.y = position.y + 25.0
    else
        b.position.x = position.x - 30.0
        b.position.y = position.y + 18.0
    push(bullets, b)


def remove_out_of_screen_bullet(var forceRemoveIdx: int)
    if(forceRemoveIdx >= 0)
        erase(bullets, forceRemoveIdx)

    let index = find_index_if(bullets) <| $(item)
        return item.position.x > float(get_screen_width()) + float(item.size.x)

    if index >= 0
        erase(bullets, index)


def is_target_hited(var b: Bullet; var targetPos: float2; var targetSize: float2)
    return (b.position.y >= float(targetPos.y - targetSize.y / 4.0)
         && b.position.y <= float(targetPos.y + targetSize.y)
         && b.position.x >= float(targetPos.x - targetSize.x / 2.0)
         && b.position.x <= float(targetPos.x + targetSize.x / 2.0))