
require daslib/media
require graphics

var
    bee_img: Image <- create_image("content/enemies/bee.png")
let
    size_bee = int2(float(bee_img.width) * 0.7, float(bee_img.height) * 0.7)

var bee_dead: PcmSound <- create_sound("content/sounds/enemies/boom.mp3")

struct Enemy
    alive: bool
    passed: bool
    position: float2
    size: float2
    holeTop: float
    holeBottom: float
    hp: float
    velocity: float2

var
    enemies: array<Enemy>
    randFloat: int4
    enemiesKilled: int
    enemies_count: float
    vel = float2(5.0, 0.0)
    shoudGradeGun: bool


def init_enemy(var e: Enemy)
    e.alive = true
    e.hp = 10.0
    e.passed = false
    e.size = float2(size_bee)
    e.position.x = float(get_screen_width()) + e.size.x
    e.position.y = clamp((random_float(randFloat)) * float(get_screen_height()), 0.0 + e.size.y * 0.2, float(get_screen_height()) - e.size.y)
    e.velocity = vel

def take_damage_enemy(var e: Enemy; var damage: float)
    e.hp -= damage
    if(e.hp <= 0.0)
        kill_enemy(e)

def enemies_count_update()
    if enemiesKilled % 10 == 0 && enemies_count > 2.0
        enemies_count -= 3.0
    if enemiesKilled % 10 == 0 && enemies_count <= 2.0
        vel = float2(vel.x + 1.0, 0.0)


def kill_enemy(var e: Enemy)
    e.alive = false
    play_sound(bee_dead, 0.1)
    enemiesKilled++
    enemies_count_update()


def render_enemy(var e: Enemy)
    let x = e.position.x
    let y = e.position.y
    fill_rect(int(x), int(y - 10.0), 11 * 10, 10, 0x000000);
    fill_rect(int(x), int(y - 10.0), int(e.hp + 1.0) * 10, 10, 0xAA0000);
    enable_alpha_blend()
    draw_image(bee_img, int(e.position.x), int(e.position.y), 0xFFFFFFFF, size_bee)
    disable_alpha_blend()


def update_enemy(var e: Enemy)
    e.position.x -= e.velocity.x
    e.position.y -= e.velocity.y


def check_for_new_enemies()
    if length(enemies) == 0 || enemies[length(enemies) - 1].position.x < float(get_screen_width()) - float(get_screen_width()) * random_float(randFloat) * enemies_count
        var e: Enemy
        init_enemy(e)
        push(enemies, e)


def remove_out_of_screen_enemies(var forceRemoveEnemyIdx: int)
    if(forceRemoveEnemyIdx >= 0 && !enemies[forceRemoveEnemyIdx].alive)
        erase(enemies, forceRemoveEnemyIdx)

    let index = find_index_if(enemies) <| $(item)
        return item.position.x <= 0.0 - item.size.x

    if index >= 0
        erase(enemies, index)




