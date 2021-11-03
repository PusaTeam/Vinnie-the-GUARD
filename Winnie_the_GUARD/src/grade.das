require daslib/media

struct updrade
    damage: float
    vel: float2

var randFloat: int4

def spawn_grade()
    var randGrade = random_float(randFloat)
    var isDmgGrade = random_float(randFloat) >= 0.5
    print("{randGrade} {isDmgGrade}")