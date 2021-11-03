require daslib/media
require src/plane
require src/clouds
require src/weapons
require src/enemies

var
    back_music: PcmSound <- create_sound("content/sounds/back/back.mp3")
    start_music: PcmSound <- create_sound("content/sounds/back/start.mp3")
    lives_music: PcmSound <- create_sound("content/sounds/back/lives.mp3")
    bullet_sound: PcmSound <- create_sound("content/sounds/ammo/default.mp3")
    bomb_sound: PcmSound <- create_sound("content/sounds/ammo/BAZOOK.mp3")
    bee_damaged: PcmSound <- create_sound("content/sounds/ammo/bee_damaged.mp3")
    tree_img : Image <- create_image("content/background/tree.png")
    pig_img : Image <- create_image("content/background/pig.png")
    back_img : Image <- create_image("content/background/bg.png")

let
    volume = 0.3
    size_tree = int2(float(bee_img.width) * 4.0, float(bee_img.height) * 4.0)
    backSize = int2(get_screen_width(), get_screen_height())
    pigSize = int2(float(bee_img.width), float(bee_img.height))
var
    plane: Plane
    lives = 3
    SKY_COLOR_DAY   = 0xB0E0FF
    SKY_COLOR_NIGHT = 0x013253
    currentWeapon = "BAZOOK"
    timeToFire = weapons[currentWeapon].ttf
    score: int
    randWeaponFloat : int4
    shoudGrade: bool
    difficulty: int
    pigPosX = 0
    pigDirect = 1
    pigRight = true



def render_background()
    var color = SKY_COLOR_DAY
    if enemiesKilled % 20 <= 10
        color = SKY_COLOR_DAY
    else
        color = SKY_COLOR_NIGHT
    fill_rect(0, 0, get_screen_width(), get_screen_height(), color)
    enable_alpha_blend()
    draw_image(back_img, 0, 0, 0xFFFFFFFF, backSize)
    draw_image(tree_img, -220, 125, 0xFFFFFFFF, size_tree)
    draw_image(pig_img, get_screen_width() -  pigSize.x, get_screen_height() - pigSize.y, 0xFFFFFFFF, pigSize)
    disable_alpha_blend()



[export]
def initialize
    set_window_title("Winnie the GUARD")
    get_screen_width()
    get_screen_height()
    set_resolution(1600, 900)
    reset_plane(plane)
    lives = 3
    score = 0
    enemiesKilled = 0
    play_sound(start_music, volume)
    play_sound_loop(back_music, volume)
    clear(bullets)
    clear(clouds)
    clear(enemies)
    set_font_size(25)
    enemies_count = 20.0
    randomize_seed(randWeaponFloat)
    currentWeapon = weaponsArr[int(random_float(randWeaponFloat) * 1000.0) % length(weaponsArr)]
    return

def togglePigPos()
    if pigRight
        pigDirect =  1
    else
        pigDirect = -1
    pigRight = !pigRight

def update_input(dt: float)
    let up = get_key(VK_UP) || get_key(VK_W)
    let down = get_key(VK_DOWN) || get_key(VK_S)
    let right = get_key(VK_RIGHT) || get_key(VK_D)
    let left = get_key(VK_LEFT) || get_key(VK_A)
    let fire = get_key(VK_LCONTROL) || get_key(VK_SPACE)
    timeToFire -= dt
    if lives == 0 && fire
        initialize()

    if plane.alive && left
        hor_movement_plane(plane, -1.0)
    elif plane.alive && right
        hor_movement_plane(plane, 1.0)

    if plane.alive && up
        vert_movement_plane(plane, -1.0)
    elif plane.alive && down
        vert_movement_plane(plane, 1.0)

    if plane.alive && fire && timeToFire <= 0.0
        let bulletPosition = float2(plane.position.x, plane.position.y)
        add_bullet(bulletPosition, currentWeapon)
        if currentWeapon == "BAZOOK"
            play_sound(bomb_sound, 0.3)
        else
            play_sound(bullet_sound, 0.1)
        timeToFire = weapons[currentWeapon].ttf


def update_gameplay()
    update_plane(plane)
    for c in clouds
        update_cloud(c)
        if c.position.x + c.size.x < float(get_screen_width())
            c.passed = true

    var forceRemoveBulletIdx = -1
    var forceRemoveEnemyIdx = -1
    for eIdx in range(length(enemies))
        update_enemy(enemies[eIdx])
        if enemies[eIdx].position.x + enemies[eIdx].size.x <= 0.0
            enemies[eIdx].passed = true
            lives--
            play_sound(lives_music, 0.3)
        for bIdx in range(length(bullets))
            if is_target_hited(bullets[bIdx], enemies[eIdx].position, enemies[eIdx].size)
                play_sound(bee_damaged, 0.1)
                take_damage_enemy(enemies[eIdx], bullets[bIdx].damage)
                forceRemoveBulletIdx = bIdx
                forceRemoveEnemyIdx = eIdx

    score = enemiesKilled
    check_for_new_clouds()
    check_for_new_enemies()
    remove_out_of_screen_clouds()
    remove_out_of_screen_enemies(forceRemoveEnemyIdx)
    remove_out_of_screen_bullet(forceRemoveBulletIdx)
    if get_time_after_start() > 0.0 && get_time_after_start() % 10.0  <= 0.01
        shoudGrade = true

    if get_time_after_start() > 0.0 && int(get_time_after_start()) % 10 == 0 && shoudGrade
        if(currentWeapon == "BAZOOK" &&  weapons[currentWeapon].ttf >= 0.0)
            weapons[currentWeapon].ttf -=  0.05
        else
            weapons[currentWeapon].damage += 0.05
        shoudGrade = false
    difficulty = int(enemiesKilled / 10) + 1
    print("{get_screen_width() - pigSize.x <= pigPosX} { pigPosX - pigSize.x < pigSize.x * -3}\n")

    if(lives == 0)
        clear(bullets)
        clear(clouds)
        clear(enemies)
        delete back_music

[export]
def act(dt: float)
    if get_key(VK_ESCAPE)
        schedule_quit_game()
    update_input(dt)
    update_gameplay()


[export]
def draw()
    render_background()
    if lives == 0
        text_out(450, get_screen_height() / 2, "PRESS SPACE TO PLAY", 0x000000)
        text_out(450, get_screen_height() / 2 - 200, "W/A/S/D || Arrows - MOVEMENT", 0x000000)
        text_out(450, get_screen_height() / 2 - 100, "LCTRL || SPACE - SHOOTING", 0x000000)
        text_out(450, get_screen_height() / 2 + 100, "Little Vinnie already stole a lot of honey from the bees and \nhid it at the top of the oak tree. But the bees found his lair \nand now he will have to sacrifice his life for his favorite treat...", 0x000000)
    else
        for c in clouds
            render_cloud(c)

        for e in enemies
            render_enemy(e)

        for b in bullets
            bullet_update(b)
            bullet_render(b, currentWeapon)


        render_plane(plane, currentWeapon)
        text_out(50, 10, "lives:{lives}", 0x000000)
        text_out(200, 10, "Score:{score}", 0x000000)
        text_out(350, 10, "Gun:{currentWeapon}", 0x000000)
        (currentWeapon == "BAZOOK"
            ? text_out(550, 10, "Bomb cd:{int(weapons[currentWeapon].ttf * 100.0)} ", 0x000000)
            : text_out(550, 10, "Gunpower:{int(weapons[currentWeapon].damage * 100.0) / 10} ", 0x000000))
        text_out(775, 10, "Difficulty:{difficulty}", 0x000000)