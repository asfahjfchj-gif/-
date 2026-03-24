-- // Ultimate Hack (V8) - TARGET MODAL & LOOP TP
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    task.wait()
    LocalPlayer = Players.LocalPlayer
end

local Camera = Workspace.CurrentCamera
while not Camera do
    task.wait()
    Camera = Workspace.CurrentCamera
end

local Mouse = LocalPlayer:GetMouse()

local guiParent
pcall(function() guiParent = game:GetService("CoreGui") end)
if not guiParent then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

-- // Settings
local Settings = {
    ESP = { Enabled = false, ShowName = false, ShowHP = false, ShowDistance = false, Chams = false, Tracers = false, GlowEffect = false, RainbowChams = false, DmgIndicator = false, VisibleColor = Color3.fromRGB(0, 255, 150), HiddenColor = Color3.fromRGB(255, 50, 50), Crosshair = false,
        BoxESP = false, SkeletonESP = false, HeadDot = false, SnapLines = false, ViewAngles = false, ProximityWarn = false, ProximityDist = 30, NightVision = false, ThirdPerson = false, ThirdPersonDist = 10, Freecam = false, NoFog = false, NoShadows = false, CrosshairSize = 8, FOVCircleColor = 1, BrightPlayers = false, WeaponESP = false, NameplateSize = 1, TargetIndicator = false, KillCounter = false,
        BulletTracers = false, OffScreenArrows = false, Radar = false, ChamsMaterial = "Neon", FOVThickness = 1, CrosshairSpin = false, CrosshairGap = 5, ItemESP = false, ZoomIn = false, ZoomOut = false, TargetHighlight = false, WallHackV2 = false, SpectatorList = false },
    Aimbot = { Enabled = false, ShowFOV = true, Radius = 150, Smoothing = 5, TargetPart = "Head", SmartAim = false, WallCheck = false, Prediction = false, PredictFactor = 0.15, SilentAim = false,
        Jitter = false, JitterAmount = 3, TargetLock = false, AutoSwitch = false, FlickBot = false, StickyAim = false, StickyTime = 0.5, BodyAimPriority = false, AimAssist = false, AimAssistStr = 0.3, AutoShoot = false, MaxAngle = 180 },
    Combat = { NoRecoil = false, TriggerBot = false, TriggerBotDelay = 0.05,
        RapidFire = false, RapidFireDelay = 0.03, KillAura = false, KillAuraRange = 15, Reach = false, ReachDist = 20, AutoBlock = false, AutoParry = false, FastAttack = false, ClickTPAttack = false, TargetStrafe = false, StrafeRadius = 8, StrafeSpeed = 3, AutoBackstab = false, ComboMode = false,
        AutoReload = false, NoSpread = false, BowAimbot = false, AutoClicker = false, HitboxExtenderArms = false, MagnetAimbot = false, MeleeAura = false, KeepDistance = false, HitChams = false, HitSound = false, AimbotPriority = 1, Wallbang = false, TeammateHealer = false, AutoToxic = false },
    Hitbox = { Enabled = false, Size = 6, Transparency = 0.5, ProximityShrink = false, ShrinkDist = 25, EntityHitbox = false, EntitySize = 8, ExpandAllParts = true },
    AimbotIgnoreList = {},
    Movement = { Fly = false, Speed = 50, Noclip = false, InfJump = false, BHop = false, JumpPowerOn = false, JumpPowerVal = 50, AntiVoid = false, CFrameSpeed = false, CFrameSpeedVal = 2, TPtoMouse = false, Spider = false, AntiKnockback = false, LagSpeed = false, LagSpeedVal = 5, WalkSpeedOn = false, WalkSpeedVal = 16,
        LongJump = false, LongJumpPower = 80, HighJump = false, HighJumpPower = 100, Glide = false, GlideSpeed = 20, FreezePos = false, Dash = false, DashPower = 60, TPForward = false, TPForwardDist = 15, AutoWalk = false, FollowPlayer = false, OrbitPlayer = false, OrbitRadius = 10, OrbitSpeed = 2, InvPlatform = false, JesusWalk = false, Phase = false, MoonJump = false, SlideOn = false, StepOn = false, AutoSprint = false, SpeedPulse = false, SpeedPulseMin = 16, SpeedPulseMax = 50, TPUp = false, TPDown = false, SafeWalk = false, EdgeJump = false, BunnyFly = false,
        ReverseWalk = false, Hover = false, SpaceJump = false, FlipGravity = false, WalkOnWalls = false, AutoJump = false, StrafeOptimizer = false, FakeLagV1 = false, TweenTP = false, VehicleFly = false, VehicleSpeed = false, AutoPilot = false, StepBack = false },
    TP = { SpectateIndex = 1, LoopTP = false, TargetPlayer = nil, Spectating = false, SpectateTarget = nil },
    Rage = { Spinbot = false, AntiAim = false },
    World = { Fullbright = false, XRay = false, FOV = 70, LowGravity = false, GravityVal = 50, TimeOfDayOn = false, TimeOfDay = 14,
        Wireframe = false, WireframeTrans = 0.7, RemoveDecals = false, RemoveMeshes = false, BigHead = false, BigHeadSize = 5, SmallPlayers = false, SmallScale = 0.5, CustomAmbient = false, AmbientR = 128, AmbientG = 128, AmbientB = 255, RemoveWater = false, AutoDayNight = false, WorldFreeze = false, BrightOutlines = false, RemoveTerrain = false, NoCamShake = false, NoHUD = false, RemoveParticles = false,
        ClearWeather = false, CustomSkybox = false, RainbowSky = false, AcidTrip = false, NoTextures = false, DarkMode = false, InvertColors = false, FogColor = false, WaterColor = false, GrassColor = false, RemoveTrees = false, RemoveDoors = false, DisableKillbricks = false, BouncyWorld = false, SlipperyWorld = false },
    Misc = { TeamCheck = false, ChatSpam = false, SpamText = "Rivals Premium Cheat!", SpamDelay = 2,
        FPSDisplay = false, CoordsDisplay = false, PlayerJoinAlert = false, InstantRespawn = false, NoFallDmg = false, CopyOutfit = false, BringAll = false, PlayerCount = false, SpeedDisplay = false, AutoChat = false, AutoChatText = "GG!", ClockDisplay = false, MemoryCleaner = false, AutoRejoinKick = false,
        DanceSpam = false, FlingPlayer = false, FlyOnPlayer = false, AnnoyPlayer = false, StealOutfits = false, ChatSpamV2 = false, IYLoad = false, DEXLoad = false, RemoteSpyLoad = false, AutoBuyUI = false, PlayCustomAudio = false, TrollFaces = false, FakeAdmin = false, DisconnectFake = false, ItemInspector = false },
    Config = { AntiAFK = true, AutoRespawn = true },
    Protection = { AntiScreenshot = false, AntiKick = false, AntiLag = false,
        AntiFling = false, AntiTP = false, AntiSlow = false, AntiBlind = false, AntiTrap = false, FPSBoost = false, LagSwitch = false, SpoofName = false, SpoofText = "Player", AntiGravChange = false, ServerCrasher = false,
        AntiDeath = false, AntiGrab = false, GhostMode = false, CrashSpammer = false, InvisibleV2 = false, GodModeV2 = false, NoClipV2 = false, AdminDetector = false, AntiLog = false, HWIDLoggerFake = false },
    PerfGuard = { Enabled = false, MinFPS = 30 },
    Theme = { Current = "Default" }
}

-- // LOCALIZATION (EN)
local Locale = {
    on = "ON", off = "OFF",
    header = "    ULTIMATE HACK  ·  V8",
    players_header = "    PLAYERS  ·  TARGET",
    tab_visuals = "👁  VISUALS", tab_combat = "⚔  COMBAT", tab_movement = "►  MOVEMENT",
    tab_world = "🌐  WORLD", tab_rage = "◆  RAGE", tab_protection = "🛡  PROTECTION", tab_settings = "⚙  SETTINGS",
    tab_binds = "🔑  BINDS", tab_theme = "🎨  THEME",
    rejoin = "Rejoin", server_hop = "Server Hop",
    hide_menu = "Hide Menu (Panic - HOME)", anti_afk = "Anti-AFK",
    team_check = "TeamCheck (Ignore Team)", save_config = "Save Config",
    load_config = "Load Config", saved = "Saved!", loaded = "Loaded!",
    -- VISUALS
    esp_main = "◈ ESP (Main)", esp_names = "  ├ Names", esp_distance = "  ├ Distance",
    esp_hp = "  ├ HP (Health)", esp_chams = "  ├ Chams (Fill)", esp_tracers = "  └ Tracers",
    show_fov = "Show FOV Circle", glow_effect = "Glow Effect",
    rainbow_chams = "Rainbow Chams", dmg_indicator = "Damage Indicator (-HP)",
    crosshair = "Custom Crosshair", crosshair_size = "Crosshair Size",
    box_esp = "Box ESP (2D)", skeleton_esp = "Skeleton ESP", head_dot = "Head Dot",
    snap_lines = "Snap Lines (Crosshair)", view_angles = "View Angles",
    proximity_warn = "Proximity Warning", proximity_dist = "Proximity Distance",
    night_vision = "Night Vision (Green)", third_person = "Third Person", third_person_dist = "3rd Person Distance",
    freecam = "Freecam (Detach)", no_fog = "No Fog", no_shadows = "No Shadows",
    fov_circle_color = "FOV Circle Color Cycle", bright_players = "Bright Players (Light)",
    weapon_esp = "Weapon/Tool ESP", nameplate_size = "Nameplate Scale",
    target_indicator = "Target Indicator (Arrow)", kill_counter = "Kill Counter (On Screen)",
    -- COMBAT
    aimbot = "Aimbot (RMB)", silent_aim = "Silent Aim",
    no_recoil = "No Recoil", triggerbot = "TriggerBot (Auto Shoot)",
    wallcheck = "Aimbot WallCheck", aim_target = "Aimbot Target",
    aim_target_head = "Head", aim_target_body = "Body",
    aim_speed = "Aimbot Speed", aim_fov = "Aimbot FOV Radius",
    prediction = "Aimbot Prediction", predict_power = "Prediction Power",
    smart_aim = "Smart Aim", hitbox = "Hitbox Expander", hitbox_size = "Head Size",
    hitbox_prox_shrink = "Proximity Shrink", hitbox_shrink_dist = "Shrink Distance", hitbox_entity = "Entity Hitbox", hitbox_entity_size = "Entity Head Size", item_inspector = "Item Inspector (T)",
    rapid_fire = "Rapid Fire", rapid_fire_delay = "Rapid Fire Delay",
    aimbot_jitter = "Aimbot Jitter (Anti-Detect)", jitter_amount = "Jitter Amount",
    target_lock = "Target Lock (Keep Target)", auto_switch = "Auto Switch Target",
    flick_bot = "Flick Bot (Instant Snap)", sticky_aim = "Sticky Aim",
    sticky_time = "Sticky Duration", body_aim = "Body Aim Priority",
    aim_assist = "Aim Assist (Soft)", aim_assist_str = "Assist Strength",
    auto_shoot = "Auto Shoot (No RMB)", max_angle = "Max Aim Angle",
    kill_aura = "Kill Aura (AOE)", kill_aura_range = "Aura Range",
    reach = "Reach (Melee Extend)", reach_dist = "Reach Distance",
    auto_block = "Auto Block", auto_parry = "Auto Parry",
    fast_attack = "Fast Attack", click_tp_attack = "Click TP Attack",
    target_strafe = "Target Strafe", strafe_radius = "Strafe Radius", strafe_speed = "Strafe Speed",
    auto_backstab = "Auto Backstab", combo_mode = "Combo Mode",
    -- MOVEMENT
    noclip = "Noclip", fly = "Fly", fly_speed = "Fly Speed", fly_minus = "  -  ", fly_plus = "  +  ", fly_reset = "Reset 10", inf_jump = "Infinite Jump",
    bhop = "BHop", jumppower_hack = "JumpPower Hack", jumppower = "JumpPower", cframe_speed = "CFrame Speed",
    cframe_power = "CFrame Speed Power", anti_void = "Anti-Void",
    spider = "Spider (Wall Walk)", anti_kb = "Anti-Knockback",
    tp_mouse = "TP to Mouse (X)", lag_speed = "Lag Speed (Ping)",
    lag_speed_power = "Lag Speed Power", walk_speed = "WalkSpeed Hack", walk_speed_val = "WalkSpeed",
    long_jump = "Long Jump", long_jump_power = "Long Jump Power",
    high_jump = "High Jump", high_jump_power = "High Jump Power",
    glide = "Glide (Slow Fall)", glide_speed = "Glide Speed",
    freeze_pos = "Freeze Position", dash = "Dash (Burst)",
    dash_power = "Dash Power", tp_forward = "TP Forward",
    tp_forward_dist = "TP Forward Distance", auto_walk = "Auto Walk",
    follow_player = "Follow Player", orbit_player = "Orbit Player",
    orbit_radius = "Orbit Radius", orbit_speed = "Orbit Speed",
    inv_platform = "Invisible Platform", jesus_walk = "Jesus Walk (Water)",
    phase = "Phase (Thin Walls)", moon_jump = "Moon Jump (Multi)",
    slide_on = "Slide", step_on = "Step (Climb)", auto_sprint = "Auto Sprint",
    speed_pulse = "Speed Pulse", speed_pulse_min = "Pulse Min Speed", speed_pulse_max = "Pulse Max Speed",
    tp_up = "TP Up (50 studs)", tp_down = "TP Down (50 studs)",
    safe_walk = "Safe Walk (No Edge Fall)", edge_jump = "Edge Jump",
    bunny_fly = "Bunny Fly (Hop Fly)",
    -- WORLD
    fullbright = "Fullbright", fov_camera = "Camera FOV",
    low_gravity = "Low Gravity", low_grav_val = "Gravity Force",
    time_of_day_on = "Custom Time of Day", time_of_day = "Time of Day (Hour)",
    xray = "X-Ray (Transparent Walls)", wireframe = "Wireframe Mode", wireframe_trans = "Wireframe Transparency",
    remove_decals = "Remove Decals", remove_meshes = "Remove Meshes",
    big_head = "Big Head (Enemies)", big_head_size = "Big Head Size",
    small_players = "Small Players", small_scale = "Small Scale",
    custom_ambient = "Custom Ambient Color",
    remove_water = "Remove Water", auto_day_night = "Auto Day/Night Cycle",
    world_freeze = "World Freeze (Anims)", bright_outlines = "Bright Outlines",
    remove_terrain = "Remove Terrain Details", no_cam_shake = "No Camera Shake",
    no_hud = "No HUD (Hide Game UI)", remove_particles = "Remove Particles (Loop)",
    -- RAGE
    open_target = "◆  Open Target Window", stop_spectate = "Stop Spectate",
    spinbot = "Spinbot", anti_aim = "Anti-Aim (Head Desync)", god_mode = "God Mode",
    -- PROTECTION
    anti_kick = "Anti-Kick", anti_ss = "Anti-Screenshot", anti_lag = "Anti-Lag (Remove FX)",
    anti_fling = "Anti-Fling", anti_tp = "Anti-Teleport (Block TP)",
    anti_slow = "Anti-Slow (Block Speed Down)", anti_blind = "Anti-Blind (Remove Blur)",
    anti_trap = "Anti-Trap (Destroy Traps)", fps_boost = "FPS Boost (Remove Clutter)",
    lag_switch = "Lag Switch (Toggle)", spoof_name = "Spoof Display Name",
    anti_grav_change = "Anti-Gravity Change", server_crasher = "Server Crasher",
    -- MISC / SETTINGS
    search = "Search...", selected = "Selected", selected_none = "None",
    loop_tp = "Loop TP", spectate = "Spectate", tp_to = "TP to Player",
    chat_spam = "Chat Spam", spam_text = "Spam Text", spam_delay = "Spam Delay (sec)",
    fps_display = "FPS Display", coords_display = "Coordinates Display",
    player_join_alert = "Player Join Alert", instant_respawn = "Instant Respawn",
    no_fall_dmg = "No Fall Damage", copy_outfit = "Copy Target Outfit",
    bring_all = "Bring All Players", player_count = "Player Count Display",
    speed_display = "Speed Display", auto_chat = "Auto Chat on Kill",
    auto_chat_text = "Auto Chat Text", clock_display = "Clock Display",
    memory_cleaner = "Memory Cleaner", auto_rejoin_kick = "Auto-Rejoin on Kick",
    -- NOTIFICATIONS
    notify_rejoin = "Rejoining in 2 sec...", notify_search_server = "Searching server...",
    notify_no_server = "⚠ No free server found", notify_server_error = "⚠ Server list error",
    notify_esp_on = "ESP Enabled", notify_esp_off = "ESP Disabled",
    notify_esp_first = "⚠ Enable ESP first!",
    notify_team_on = "TeamCheck: Teammates ignored", notify_team_off = "TeamCheck: All players are enemies",
    notify_wallcheck = "WallCheck: Aimbot won't aim through walls",
    notify_silent = "Silent Aim: Bullets hit target invisibly",
    notify_smart_aim = "Smart Aim: Aimbot picks visible body part",
    notify_anti_kick = "Anti-Kick: Kick attempts will be blocked",
    notify_anti_kick_blocked = "Anti-Kick: Kick blocked!",
    notify_anti_ss = "GUI hidden from screenshots",
    notify_anti_lag = "Anti-Lag: Removed %d effects",
    notify_auto_respawn = "Auto-Respawn: Settings restored!",
    notify_anti_aim = "Anti-Aim: Head hitbox desynced",
    -- VISUALS V2
    bullet_tracers = "Bullet Tracers", off_screen_arrows = "Off-Screen Arrows", radar = "Radar (Minimap)", chams_material = "Chams Material",
    fov_thickness = "FOV Outline Thickness", crosshair_spin = "Spinning Crosshair", crosshair_gap = "Crosshair Gap", item_esp = "Item ESP",
    zoom_in = "Zoom In (Binoculars)", zoom_out = "Zoom Out (Ultra WFOV)", target_highlight = "Target Highlight", wall_hack_v2 = "Wall Hack V2", spectator_list = "Spectator List",
    -- COMBAT V2
    auto_reload = "Auto Reload", no_spread = "No Spread", bow_aimbot = "Bow Aimbot", auto_clicker = "Auto Clicker",
    hitbox_ext_arms = "Hitbox Expander (Arms/Legs)", magnet_aim = "Magnet Aimbot", melee_aura = "Melee Aura", keep_dist = "Keep Distance",
    hit_chams = "Hit Chams", hit_sound = "Hit Sound", aimbot_priority = "Aimbot Priority", wallbang = "Wallbang",
    team_healer = "Teammate Healer", auto_toxic = "Auto Toxic",
    -- MOVEMENT V2
    reverse_walk = "Reverse Walk", hover = "Hover (Freeze Y)", space_jump = "Space Jump", flip_gravity = "Flip Gravity",
    walk_walls = "Walk On Walls", auto_jump = "Auto Jump", strafe_opt = "Strafe Optimizer", fake_lag_v1 = "Fake Lag",
    tween_tp = "Tween TP", veh_fly = "Vehicle Fly", veh_speed = "Vehicle Speed", auto_pilot = "Auto-Pilot", step_back = "Step Back",
    -- WORLD V2
    clear_weather = "Clear Weather", custom_skybox = "Custom Skybox", rainbow_sky = "Rainbow Sky", acid_trip = "Acid Trip Mode",
    no_textures = "No Textures (Plastic)", dark_mode = "Dark Mode", invert_colors = "Invert Colors", fog_color = "Fog Color",
    water_color = "Water Color", grass_color = "Grass Color", remove_trees = "Remove Trees", remove_doors = "Remove Doors",
    disable_killbricks = "Disable Killbricks", bouncy_world = "Bouncy World", slippery_world = "Slippery World",
    -- PROTECTION V2
    anti_death = "Anti-Death", anti_grab = "Anti-Grab", ghost_mode = "Ghost Mode", crash_spammer = "Crash Spammer",
    invisible_v2 = "Invisible V2", god_mode_v2 = "God Mode V2", noclip_v2 = "No Clip V2", admin_detect = "Admin Detector",
    anti_log = "Anti-Log", hwid_fake = "HWID Spoof / Fake",
    -- MISC V2
    dance_spam = "Dance Spam", fling_player = "Fling Player", fly_on_player = "Fly On Player", annoy_player = "Annoy Player",
    steal_outfits = "Steal Outfits", chat_spam_v2 = "Chat Spam V2 (Lyrics)", iy_load = "Infinite Yield Load", dex_load = "DEX Explorer Load",
    remote_spy = "Remote Spy Load", auto_buy_ui = "Auto Buy UI", play_audio = "Play Custom Audio", troll_faces = "Troll Faces",
    fake_admin = "Fake Admin", disconnect_fake = "Disconnect Fake",
    -- PERFGUARD / SORTING / BINDS / THEMES
    perf_guard = "PerfGuard", perf_guard_fps = "PerfGuard FPS Threshold",
    notify_perf_on = "PerfGuard: Auto-optimize at low FPS",
    notify_perf_triggered = "⚡ PerfGuard: Low FPS! Disabled heavy effects",
    sort_distance = "📏 Dist", sort_name = "A-Z", sort_hp = "❤ HP", sort_visible = "👁 Vis",
    bind_menu = "Menu Toggle", bind_fly = "Fly Toggle", bind_panic = "Panic Hide", bind_tp_mouse = "TP to Mouse",
    bind_press_key = "[Press any key...]",
    theme_default = "Cyberpunk", theme_neon = "Neon", theme_terminal = "Terminal", theme_toxic = "Toxic", theme_clean = "Clean",
    notify_theme = "Theme: %s",
    notify_bind_set = "Bind: %s → %s",
}

local Tooltips = {
    [Locale.esp_main] = "Главный переключатель ВХ. Показывает врагов за стенами.",
    [Locale.esp_names] = "Отображает имена игроков сверху.",
    [Locale.esp_distance] = "Сколько метров до игрока.",
    [Locale.esp_hp] = "Уровень здоровья противника.",
    [Locale.esp_chams] = "Заливает текстуру противника ярким цветом через стену.",
    [Locale.esp_tracers] = "Рисует линии от вас до других игроков.",
    [Locale.show_fov] = "Круг радиуса Аимбота на экране.",
    [Locale.glow_effect] = "Светящаяся аура вокруг противников.",
    [Locale.rainbow_chams] = "Чамсы переливаются всеми цветами радуги.",
    [Locale.dmg_indicator] = "Показывает отнимаемое ХП врага при уроне.",
    [Locale.crosshair] = "Рисует свой прицел в центре экрана.",
    [Locale.crosshair_size] = "Регулировка размера своего прицела.",
    [Locale.box_esp] = "Квадратные рамки 2D вокруг игроков.",
    [Locale.skeleton_esp] = "Полки-скелеты игроков через стену.",
    [Locale.head_dot] = "Маленькая точка прямо на головах врагов.",
    [Locale.snap_lines] = "Линия от прицела до ближайшей цели.",
    [Locale.view_angles] = "Показывает куда сейчас смотрит враг.",
    [Locale.proximity_warn] = "Справа напишет, если враг подошёл слишком близко.",
    [Locale.proximity_dist] = "С какой дистанции предупреждать об опасности.",
    [Locale.night_vision] = "Зеленый фильтр, светло как днем, без тумана.",
    [Locale.third_person] = "Включает вид от 3-го лица с регулировкой отдаления.",
    [Locale.third_person_dist] = "На сколько стадов отдалить камеру.",
    [Locale.freecam] = "Отсоединяет камеру от персонажа, летай как админ.",
    [Locale.no_fog] = "Полностью урезает туман на карте.",
    [Locale.no_shadows] = "Убирает все тени, повышает ФПС.",
    [Locale.fov_circle_color] = "Меняет цвет круга FOV.",
    [Locale.bright_players] = "Включает материал Neon для тел игроков.",
    [Locale.weapon_esp] = "Пишет, какое оружие игрок держит в руках.",
    [Locale.nameplate_size] = "Увеличивает текст над игроками (ESP).",
    [Locale.target_indicator] = "Стрелочка, указывающая на захваченную Аимом цель.",
    [Locale.kill_counter] = "Счётчик заработанных убийств.",

    [Locale.aimbot] = "Авто-наводка на голову/тело, когда зажат бинд.",
    [Locale.silent_aim] = "Невидимая наводка пуль. Стреляй рядом, а попадешь в цель.",
    [Locale.no_recoil] = "Отключает отдачу камеры от стрельбы.",
    [Locale.triggerbot] = "Оружие стреляет само, если в прицеле враг.",
    [Locale.wallcheck] = "Не даёт аимботу наводиться через непробиваемые стены.",
    [Locale.aim_target] = "На что наводиться: в Голову или в Тело.",
    [Locale.aim_speed] = "Насколько плавно/резко прицел идет на цель.",
    [Locale.aim_fov] = "Размер круга захвата (радиус наводки).",
    [Locale.prediction] = "Упреждение при игре со снайперками/ракетницами.",
    [Locale.predict_power] = "Настройка силы предсказания движения (м/с).",
    [Locale.smart_aim] = "Автоматически выбирает только видимую из-за стены часть тела.",
    [Locale.hitbox] = "Делает головы или тела огромными.",
    [Locale.hitbox_size] = "Степень увеличения хитбоксов врагов.",
    [Locale.hitbox_prox_shrink] = "Хитбоксы уменьшаются при приближении (как в Rivals).",
    [Locale.hitbox_shrink_dist] = "Дистанция, на которой хитбоксы начинают уменьшаться.",
    [Locale.hitbox_entity] = "Увеличивает головы мобов/NPC (сущностей).",
    [Locale.hitbox_entity_size] = "Размер голов сущностей.",
    [Locale.hitbox_expand_all] = "Увеличивает ВСЕ части тела (для Rivals и подобных игр).",
    [Locale.aimbot_ignore] = "Выпадающий список игроков, которых аимбот не трогает.",
    [Locale.item_inspector] = "Наведи и нажми T чтобы узнать название предмета.",
    [Locale.rapid_fire] = "Стреляем с максимальной скоростью кликов.",
    [Locale.rapid_fire_delay] = "Задержка выстрелов для скоростной стрельбы.",
    [Locale.aimbot_jitter] = "Тряска прицела. Чтобы меньше палиться на запись (анти-аим).",
    [Locale.jitter_amount] = "Сила тряски прицела.",
    [Locale.target_lock] = "Цель не сменится, пока вы её не убьете.",
    [Locale.auto_switch] = "При убийстве перекинет на следующего врага моментально.",
    [Locale.flick_bot] = "Резкий дёрг к цели (фликшот) за 1 кадр и обратно.",
    [Locale.sticky_aim] = "Прилипающий аим. Трудно сорвать прицел руками с врага.",
    [Locale.body_aim] = "Фокусируется на теле, даже если выставлена Голова (когда впритык).",
    [Locale.aim_assist] = "Доводка легит: слегка помогает держать прицел.",
    [Locale.aim_assist_str] = "Сила легит-доводки.",
    [Locale.auto_shoot] = "Чистейшее мясо: убивает само, даже не трогай мышку.",
    [Locale.max_angle] = "Спасет спину: стреляет даже назад.",
    [Locale.kill_aura] = "АОЕ Урон. Дамажит всех вокруг себя (как в майнкрафте).",
    [Locale.kill_aura_range] = "Дальность КилАуры.",
    [Locale.reach] = "Мечи и кулаки бьют на расстоянии 20-30 метров.",
    [Locale.reach_dist] = "Длина удлинителя меча.",
    [Locale.auto_block] = "Сам ставит блок, если тебя хотят ударить.",
    [Locale.auto_parry] = "Идеальное парирование фрейм-в-фрейм (Rivals/BladeBall).",
    [Locale.fast_attack] = "Атака ближнего боя без задержек.",
    [Locale.click_tp_attack] = "Кликнул – ТПшнулся, ударил и вернулся обратно.",
    [Locale.target_strafe] = "Автоматический бег кругами вокруг жертвы.",
    [Locale.strafe_radius] = "Радиус бегового круга.",
    [Locale.strafe_speed] = "Как быстро носиться вокруг жертвы.",
    [Locale.auto_backstab] = "Спавнится строго за спиной цели для удара сзади.",
    [Locale.combo_mode] = "Автоматическая выдача наилучшего комбо игры.",

    [Locale.noclip] = "Летать сквозь стены (Не на всех серверах работает).",
    [Locale.fly] = "Штатный полёт по воздуху (ускоряется).",
    [Locale.fly_speed] = "Спидхак в полёте.",
    -- V2 VISUALS
    [Locale.bullet_tracers] = "Линии полета ваших пуль.",
    [Locale.off_screen_arrows] = "Стрелочки по краям экрана, указывающие на врагов сзади.",
    [Locale.radar] = "Мини-радар с позициями всех игроков.",
    [Locale.chams_material] = "Материал для чамсов (Неон, Стекло, Пластик).",
    [Locale.fov_thickness] = "Толщина линии круга FOV.",
    [Locale.crosshair_spin] = "Кастомный прицел крутится.",
    [Locale.crosshair_gap] = "Расстояние между линиями кастомного прицела.",
    [Locale.item_esp] = "Подсветка выброшенных предметов/оружия на карте.",
    [Locale.zoom_in] = "Сильное приближение (бинокль).",
    [Locale.zoom_out] = "Камера отдаляется дальше лимита игры.",
    [Locale.target_highlight] = "Сверкающая аура на цели аимбота.",
    [Locale.wall_hack_v2] = "Делает все стены полупрозрачными.",
    [Locale.spectator_list] = "Показывает, кто за вами наблюдает.",
    -- V2 COMBAT
    [Locale.auto_reload] = "Автоматическая перезарядка пушки.",
    [Locale.no_spread] = "Отключает разброс пуль (все летят в точку).",
    [Locale.bow_aimbot] = "Аимбот с расчетом падения стрелы/лука.",
    [Locale.auto_clicker] = "Встроенный автокликер для фарма.",
    [Locale.hitbox_ext_arms] = "Увеличивает руки и ноги врагов для легких попаданий.",
    [Locale.magnet_aim] = "Телепортирует ваши пули прямо во врага.",
    [Locale.melee_aura] = "Постоянно машет мечом во все стороны.",
    [Locale.keep_dist] = "Автоматически отходит назад, если враг подходит близко.",
    [Locale.hit_chams] = "Враг мигает красным при попадании.",
    [Locale.hit_sound] = "Кастомный звук при попадании (Киллсаунд).",
    [Locale.aimbot_priority] = "Кого бить первым: Ближайшего или с Лоу ХП.",
    [Locale.wallbang] = "Стреляет сквозь тонкие стены.",
    [Locale.team_healer] = "Автоматически лечит тиммейтов рядом.",
    [Locale.auto_toxic] = "Пишет оскорбления в чат после убийства врага.",
    -- V2 MOVEMENT
    [Locale.reverse_walk] = "Ходьба спиной вперед.",
    [Locale.hover] = "Замораживает падение (зависание в воздухе).",
    [Locale.space_jump] = "Прыжок невероятной высоты.",
    [Locale.flip_gravity] = "Гравитация тянет вверх.",
    [Locale.walk_walls] = "Хождение по стенам (прилипание).",
    [Locale.auto_jump] = "Авто-прыжок при зажатии пробела.",
    [Locale.strafe_opt] = "Оптимизация спама A/D чтобы по вам не попали.",
    [Locale.fake_lag_v1] = "Ваш персонаж лагает для других, уклоняясь от пуль.",
    [Locale.tween_tp] = "Плавный телепорт для обхода античитов.",
    [Locale.veh_fly] = "Машина может летать по воздуху.",
    [Locale.veh_speed] = "Невероятная скорость для автомобилей.",
    [Locale.auto_pilot] = "Персонаж сам бежит к контрольной точке.",
    [Locale.step_back] = "Откатывает вашу позицию на 3 секунды назад (Флеш).",
    -- V2 WORLD
    [Locale.clear_weather] = "Убирает дождь/снег.",
    [Locale.custom_skybox] = "Изменяет небо на кастомное красивое.",
    [Locale.rainbow_sky] = "Небо переливается цветами радуги.",
    [Locale.acid_trip] = "Случайные психоделические цвета всего мира.",
    [Locale.no_textures] = "Делает весь мир гладким пластиком (ФПС Буст).",
    [Locale.dark_mode] = "Кромешная тьма во всем мире (только ESP светится).",
    [Locale.invert_colors] = "Инверсия цветов игры.",
    [Locale.fog_color] = "Изменяет цвет тумана.",
    [Locale.water_color] = "Изменяет цвет воды.",
    [Locale.grass_color] = "Изменяет цвет травы.",
    [Locale.remove_trees] = "Удаляет все деревья с карты.",
    [Locale.remove_doors] = "Удаляет все двери на карте.",
    [Locale.disable_killbricks] = "Отключает лаву и убивающие блоки.",
    [Locale.bouncy_world] = "Мир становится батутом (игроки прыгают выше).",
    [Locale.slippery_world] = "Мир становится как лёд.",
    -- V2 PROTECTION
    [Locale.anti_death] = "Пытается удалить вашу голову при смертельном уроне для обхода смерти.",
    [Locale.anti_grab] = "Не дает другим игрокам схватить вас.",
    [Locale.ghost_mode] = "Включает режим невидимости на сервере.",
    [Locale.crash_spammer] = "Спамит пакетами для краша слабых серверов.",
    [Locale.invisible_v2] = "Новый метод невидимости.",
    [Locale.god_mode_v2] = "Более стабильный скрипт бессмертия.",
    [Locale.noclip_v2] = "Скрытный ноуклип (обходит античиты по коллизиям).",
    [Locale.admin_detect] = "Предупреждает, если на сервер зашел Админ или Модер.",
    [Locale.anti_log] = "Убивает все скрипты, которые следят за вашим клиентом.",
    [Locale.hwid_fake] = "Подменяет данные вашего устройства для обхода банов.",
    -- V2 MISC
    [Locale.dance_spam] = "Спамит всеми анимациями танцев с бешеной скоростью.",
    [Locale.fling_player] = "Подлетает к игроку и крутится, чтобы убить его физикой.",
    [Locale.fly_on_player] = "Использует игрока как ковер-самолет.",
    [Locale.annoy_player] = "Летает вокруг игрока и невероятно бесит.",
    [Locale.steal_outfits] = "Копирует одежду любого кликнутого игрока.",
    [Locale.chat_spam_v2] = "Спамит текстами песен (Лирика) в чат.",
    [Locale.iy_load] = "Загружает популярный админ-скрипт Infinite Yield.",
    [Locale.dex_load] = "Загружает DEX Explorer (поиск скриптов).",
    [Locale.remote_spy] = "Загружает Remote Spy (для изучения событий).",
    [Locale.auto_buy_ui] = "Авто-покупка в магазинах (Click UI).",
    [Locale.play_audio] = "Запускает кастомную очень громкую музыку на сервере.",
    [Locale.troll_faces] = "Меняет все декали/лица на Trollface.",
    [Locale.fake_admin] = "Дает фейковый админ-тег над головой (видят все).",
    [Locale.disconnect_fake] = "Фейковый дисконнект для пранка.",

    -- SYSTEM/MISC OVERRIDE
    [Locale.perf_guard] = "⚡ Оптимизирует запуск при просадке кадров",
    [Locale.inf_jump] = "Прыгай в небеса сколько хочешь (зажимай пробел).",
    [Locale.bhop] = "Банни Хоп. Ускоряет при прыжках подряд.",
    [Locale.jumppower_hack] = "Высота одного прыжка настраивается.",
    [Locale.cframe_speed] = "Использует телепорт для ускорения (В обход Анти-СпидХака).",
    [Locale.anti_void] = "Телепортирует обратно на карту, если ты упал в пустоту.",
    [Locale.spider] = "Карабкается по стенам как человек паук.",
    [Locale.anti_kb] = "Отключает отдачу при получении урона от кулаков/мечей.",
    [Locale.tp_mouse] = "Телепортирует на мышку (Кнопка X или назначенный бинд).",
    [Locale.lag_speed] = "Пингующий спидхак. Телепортирует рывками вперед (Беспалевно).",
    [Locale.walk_speed] = "Классический спидхак. Изменяет скорость ходьбы (WalkSpeed).",
    [Locale.long_jump] = "Длинный прыжок далеко вперёд.",
    [Locale.high_jump] = "Высокий супер-прыжок (усиленный Inf Jump).",
    [Locale.glide] = "Медленное падение словно с парашютом.",
    [Locale.freeze_pos] = "Замораживает тебя в небе.",
    [Locale.dash] = "Моментальный рывок вперед кнопкой Q.",
    [Locale.tp_forward] = "Перемещает моментально на 15+ студов по курсу.",
    [Locale.auto_walk] = "Сам жмёт W за тебя.",
    [Locale.follow_player] = "Бежит хвостиком к выбранному Target игроку.",
    [Locale.orbit_player] = "Использует орбиту и летает вкруг Target цели.",
    [Locale.inv_platform] = "Спавнит стекло у тебя под ногами невидимое.",
    [Locale.jesus_walk] = "Не проваливаешься в воду (ходишь по рекам).",
    [Locale.phase] = "Тонкая версия Noclip'а для прохождения стен в 1 блок.",
    [Locale.moon_jump] = "МунДжамп (повышенный медленный прыжок).",
    [Locale.slide_on] = "Бесконечное скольжение/подкат.",
    [Locale.step_on] = "Не нужно прыгать. Шагает даже по полу-блокам автоматом.",
    [Locale.auto_sprint] = "Бесконечный спринт без зажатия шифта.",
    [Locale.speed_pulse] = "Спидхак, который рывками меняет скорость (ломает чужой аим).",
    [Locale.safe_walk] = "Останавливается на краю бездны - защищает от падений.",
    [Locale.edge_jump] = "Если падает - сам прыгает с обрыва.",
    [Locale.bunny_fly] = "Прыжковый полёт - обходит некоторые Анти-Флаи.",

    [Locale.fullbright] = "Убирает темноту и ночь навсегда.",
    [Locale.fov_camera] = "Отдаление монитора.",
    [Locale.low_gravity] = "Луна: вы застреваете в воздухе дольше (гравитация клиента).",
    [Locale.time_of_day_on] = "Меняет время суток чисто для тебя.",
    [Locale.xray] = "Видеть всю карту насквозь полупрозрачной.",
    [Locale.wireframe] = "Режим сетки - объекты рисуются полосками, бустит ФПС до небес.",
    [Locale.remove_decals] = "Убирает текстуры картинок. Карта становится лысой, но ФПС 300+.",
    [Locale.remove_meshes] = "Удаляет детальные 3D модели (все как лего).",
    [Locale.big_head] = "Увеличивает ХэдКоллизии, делает головы гигантскими как арбузы.",
    [Locale.small_players] = "Уменьшает игроков, делая их лилипутами.",
    [Locale.custom_ambient] = "Перекрашивает атмосферу в твой заданный фильтр.",
    [Locale.remove_water] = "Вырубает текстуры воды.",
    [Locale.auto_day_night] = "Солнце гоняет по небу за секунды.",
    [Locale.world_freeze] = "Замораживает все анимации противников.",
    [Locale.no_cam_shake] = "Отключает дергания камеры при взрывах.",
    [Locale.no_hud] = "Скрывает весь инвентарь (Roblox Gui). Идеально для роликов.",
    [Locale.remove_particles] = "Очищает все партиклы огня, дыма, искр - самый мощный ФПС буст.",
    
    [Locale.open_target] = "Открывает окно с выбором цели для фокуса читов.",
    [Locale.stop_spectate] = "Перестать смотреть за другим.",
    [Locale.spinbot] = "Дико крутит персонажа - ломает чужие аимботы.",
    [Locale.anti_aim] = "Десинхронизирует вашу голову. В вас не смогут попасть в хед.",
    [Locale.god_mode] = "Бессмертие. Сервер не сможет вас убить (работает багая гуманоид).",

    [Locale.anti_kick] = "Игнорирует LocalScript кики от анти-чита.",
    [Locale.anti_ss] = "Чит-меню не будет видно при попытках снять скриншот Админом.",
    [Locale.anti_lag] = "Жесткая чистка от лагов сервера и спама деталями.",
    [Locale.anti_fling] = "Тебя не смогут откинуть другие читеры вертушкой.",
    [Locale.anti_tp] = "Игнорирует команды игр отправить вас на другой плейс.",
    [Locale.anti_slow] = "Отключает эффекты замедления.",
    [Locale.anti_blind] = "Игнорирует ослепления (флешки / яд).",
    [Locale.anti_trap] = "Разрушает любые капканы или прицепленные к вам детали-ловушки.",
    [Locale.fps_boost] = "Ультимативный Boost: удаляет весь свет и лишний рендер.",
    [Locale.lag_switch] = "Выключает Инет-пакеты. Стоите в воздухе на сервере, но ходите у себя.",
    [Locale.anti_grav_change] = "Игнорит влияние погоды карты на вас.",
    [Locale.server_crasher] = "Спамит огромными деталями под текстурами, крашит 1-ядерные серваки.",

    [Locale.search] = "Поиск...",
    [Locale.loop_tp] = "Авто-ТП на цель каждую сек.",
    [Locale.spectate] = "Следить глазами цели.",
    [Locale.tp_to] = "Телепорт",
    [Locale.chat_spam] = "Авто-реклама читов в чат каждую N секунд.",
    [Locale.fps_display] = "Счётчик кадров в секунду на экране.",
    [Locale.coords_display] = "X Y Z позиция в худе.",
    [Locale.player_join_alert] = "Оповещает звуком и текстом кто вошел.",
    [Locale.instant_respawn] = "Пропускает экран смерти и возрождает сразу.",
    [Locale.no_fall_dmg] = "Блокирует падение - нет урона с любой высоты.",
    [Locale.bring_all] = "Магнит игроков (требует тулы или права админа).",
    [Locale.player_count] = "Счетчик скольких на сервере.",
    [Locale.speed_display] = "Спидометр.",
    [Locale.clock_display] = "Часы на экране.",
    [Locale.memory_cleaner] = "Каждые 30 сек чистит ОЗУ - защита от вылета Roblox.",
    [Locale.auto_rejoin_kick] = "Авто заходит обратно, если кикнут.",
    
    [Locale.perf_guard] = "Принудительно тушит эффекты, если ФПС < порога.",
}

local function L(key) return Locale[key] or key end

local UserBinds = { Menu = Enum.KeyCode.Insert, Fly = Enum.KeyCode.Unknown, Panic = Enum.KeyCode.Home, TPMouse = Enum.KeyCode.X }
local espObjects, isVisibleCache, RGBObjects, smartAimCache = {}, {}, {}, {}
local isRmbDown, isLmbDown = false, false
local FlyVars = { bg = nil, bv = nil, ctrl = {f = 0, b = 0, l = 0, r = 0, u = 0, d = 0} }
local lagSpeedCounter = 0
local lagSpeedNextTick = math.random(3, 8)
local rainbowHue = 0
local dmgCache = {}
local dmgLabels = {}
local spiderBV = nil
local currentFPS = 60
local perfGuardTriggered = false
local currentSortMode = "distance"
local listeningBind = nil
local Themes = {
    Default = { bg = Color3.fromRGB(8, 8, 22), header = Color3.fromRGB(10, 10, 28), accent = Color3.fromRGB(0, 200, 255), btn = Color3.fromRGB(12, 12, 30), btnActive = Color3.fromRGB(0, 160, 220), text = Color3.fromRGB(0, 230, 255), stroke = Color3.fromRGB(0, 180, 255), leftMenu = Color3.fromRGB(10, 10, 26), grad1 = Color3.fromRGB(10, 10, 28), grad2 = Color3.fromRGB(5, 5, 16) },
    Neon = { bg = Color3.fromRGB(5, 5, 15), header = Color3.fromRGB(10, 10, 25), accent = Color3.fromRGB(0, 255, 100), btn = Color3.fromRGB(10, 20, 15), btnActive = Color3.fromRGB(0, 180, 80), text = Color3.fromRGB(0, 255, 150), stroke = Color3.fromRGB(0, 200, 100), leftMenu = Color3.fromRGB(5, 10, 8), grad1 = Color3.fromRGB(5, 15, 10), grad2 = Color3.fromRGB(2, 5, 5) },
    Terminal = { bg = Color3.fromRGB(0, 5, 0), header = Color3.fromRGB(5, 15, 5), accent = Color3.fromRGB(0, 255, 0), btn = Color3.fromRGB(5, 15, 5), btnActive = Color3.fromRGB(0, 180, 0), text = Color3.fromRGB(0, 255, 0), stroke = Color3.fromRGB(0, 180, 0), leftMenu = Color3.fromRGB(0, 8, 0), grad1 = Color3.fromRGB(0, 12, 0), grad2 = Color3.fromRGB(0, 4, 0) },
    Toxic = { bg = Color3.fromRGB(10, 15, 5), header = Color3.fromRGB(15, 25, 5), accent = Color3.fromRGB(180, 255, 0), btn = Color3.fromRGB(20, 30, 10), btnActive = Color3.fromRGB(140, 200, 0), text = Color3.fromRGB(200, 255, 50), stroke = Color3.fromRGB(150, 220, 0), leftMenu = Color3.fromRGB(12, 18, 4), grad1 = Color3.fromRGB(15, 22, 5), grad2 = Color3.fromRGB(5, 10, 2) },
    Clean = { bg = Color3.fromRGB(25, 25, 30), header = Color3.fromRGB(35, 35, 42), accent = Color3.fromRGB(100, 130, 255), btn = Color3.fromRGB(40, 40, 50), btnActive = Color3.fromRGB(80, 110, 220), text = Color3.fromRGB(240, 240, 255), stroke = Color3.fromRGB(150, 150, 180), leftMenu = Color3.fromRGB(30, 30, 38), grad1 = Color3.fromRGB(32, 32, 40), grad2 = Color3.fromRGB(20, 20, 28) },
}
local TeleportService = game:GetService("TeleportService")

local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if Settings.Config and Settings.Config.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end
end)

local supportDrawing = pcall(function() return Drawing.new("Line") end)
LocalPlayer.CharacterAdded:Connect(function(char)
    if Settings.Config and Settings.Config.AutoRespawn then
        task.wait(1)
        SendNotify(L("notify_auto_respawn"))
        if Settings.Movement and Settings.Movement.Fly then FlyVars.bg = nil; FlyVars.bv = nil end
    end
end)

local function IsEnemy(targetPlayer)
    if not targetPlayer then return false end
    if Settings.Misc.TeamCheck and LocalPlayer.Team ~= nil and targetPlayer.Team == LocalPlayer.Team then return false end
    return true
end

-- Smart Aim: body parts by priority (cache computed in background thread)
local smartAimParts = {
    {"Head"},
    {"UpperTorso", "Torso", "LowerTorso"},
    {"RightUpperArm", "RightLowerArm", "RightHand", "Right Arm"},
    {"LeftUpperArm", "LeftLowerArm", "LeftHand", "Left Arm"},
    {"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"},
    {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"},
}

task.spawn(function()
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    while task.wait(0.15) do
        local char = LocalPlayer.Character
        local myHead = char and char:FindFirstChild("Head")
        if myHead then
            rayParams.FilterDescendantsInstances = {char, Camera}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        local dir = head.Position - myHead.Position
                        local res = Workspace:Raycast(myHead.Position, dir, rayParams)
                        isVisibleCache[player] = (not res or res.Instance:IsDescendantOf(player.Character))
                    end
                    -- Smart Aim: cache best visible body part
                    if Settings.Aimbot.SmartAim then
                        local eChar = player.Character
                        local visibleGroups = {}
                        local visibleCount = 0
                        for groupIdx, group in ipairs(smartAimParts) do
                            for _, partName in ipairs(group) do
                                local part = eChar:FindFirstChild(partName)
                                if part and part:IsA("BasePart") then
                                    local d = part.Position - myHead.Position
                                    local r = Workspace:Raycast(myHead.Position, d, rayParams)
                                    if not r or r.Instance:IsDescendantOf(eChar) then
                                        visibleGroups[groupIdx] = part
                                        visibleCount = visibleCount + 1
                                        break
                                    end
                                end
                            end
                        end
                        if visibleCount >= 4 and visibleGroups[1] then
                            smartAimCache[player] = visibleGroups[1]
                        else
                            local found = nil
                            for i = 1, #smartAimParts do
                                if visibleGroups[i] then found = visibleGroups[i]; break end
                            end
                            smartAimCache[player] = found
                        end
                    end
                end
            end
        end
    end
end)

-- Rainbow Chams hue cycle
task.spawn(function()
    while task.wait(0.03) do
        rainbowHue = (rainbowHue + 0.005) % 1
    end
end)

-- Damage Indicator tracker
task.spawn(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then dmgCache[player] = hum.Health end
        end
    end
    while task.wait(0.1) do
        if not Settings.ESP.DmgIndicator then continue end
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local head = char and char:FindFirstChild("Head")
            if hum and head then
                local prevHP = dmgCache[player] or hum.Health
                local diff = prevHP - hum.Health
                dmgCache[player] = hum.Health
                if diff > 0.5 then
                    local bg = Instance.new("BillboardGui")
                    bg.Size = UDim2.new(0, 80, 0, 30)
                    bg.StudsOffset = Vector3.new(math.random(-2,2), 4 + math.random(0,2), 0)
                    bg.AlwaysOnTop = true; bg.Parent = head
                    local lbl = Instance.new("TextLabel", bg)
                    lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
                    lbl.Text = "-" .. math.floor(diff)
                    lbl.TextColor3 = Color3.fromRGB(255, 60, 60)
                    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 16
                    lbl.TextStrokeTransparency = 0.3
                    TweenService:Create(bg, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {StudsOffset = bg.StudsOffset + Vector3.new(0, 3, 0)}):Play()
                    TweenService:Create(lbl, TweenInfo.new(1.2), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
                    task.delay(1.3, function() bg:Destroy() end)
                end
            end
        end
    end
end)


-- Anti-Kick protection
task.spawn(function()
    task.wait(2)
    if Settings.Protection then
        local oldKick = LocalPlayer.Kick
        if oldKick then
            pcall(function()
                local mt = getrawmetatable(game)
                if mt and setreadonly then
                    setreadonly(mt, false)
                    local oldNamecall = mt.__namecall
                    mt.__namecall = newcclosure(function(self, ...)
                        if Settings.Protection.AntiKick and getnamecallmethod() == "Kick" and self == LocalPlayer then
                            SendNotify(L("notify_anti_kick_blocked"))
                            return
                        end
                        return oldNamecall(self, ...)
                    end)
                    setreadonly(mt, true)
                end
            end)
        end
    end
end)

local function ClearESP(player)
    if espObjects[player] then
        if espObjects[player].bg then espObjects[player].bg:Destroy() end
        if espObjects[player].hl then espObjects[player].hl:Destroy() end
        if espObjects[player].glow then espObjects[player].glow:Destroy() end
        if espObjects[player].tracer then espObjects[player].tracer:Remove() end
        if espObjects[player].tracerLine then espObjects[player].tracerLine:Destroy() end
        if espObjects[player].hpBg then espObjects[player].hpBg:Destroy() end
        espObjects[player] = nil
    end
end
Players.PlayerRemoving:Connect(ClearESP)

local screenGui = Instance.new("ScreenGui", guiParent)
screenGui.Name = "UltimateHack_Tabs"
screenGui.ResetOnSpawn = false

-- Custom Drag function (replaces deprecated Draggable)
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- FOV Circle
local function SendNotify(msg) pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title="Ultimate Hack", Text=msg, Duration=3}) end) end


local fovCircle
local chL, chR, chT, chB
if supportDrawing then
    fovCircle = Drawing.new("Circle"); fovCircle.Thickness = 1.5; fovCircle.Color = Color3.fromRGB(255, 255, 255); fovCircle.Filled = false
    chL = Drawing.new("Line"); chL.Thickness = 1.5; chL.Color = Color3.fromRGB(255, 255, 255)
    chR = Drawing.new("Line"); chR.Thickness = 1.5; chR.Color = Color3.fromRGB(255, 255, 255)
    chT = Drawing.new("Line"); chT.Thickness = 1.5; chT.Color = Color3.fromRGB(255, 255, 255)
    chB = Drawing.new("Line"); chB.Thickness = 1.5; chB.Color = Color3.fromRGB(255, 255, 255)
else
    fovCircle = Instance.new("Frame", screenGui); fovCircle.BackgroundTransparency = 1
    local stroke = Instance.new("UIStroke", fovCircle); stroke.Thickness = 1.5; stroke.Color = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
    chL = Instance.new("Frame", screenGui); chL.BackgroundColor3 = Color3.new(1,1,1); chL.BorderSizePixel = 0
    chR = Instance.new("Frame", screenGui); chR.BackgroundColor3 = Color3.new(1,1,1); chR.BorderSizePixel = 0
    chT = Instance.new("Frame", screenGui); chT.BackgroundColor3 = Color3.new(1,1,1); chT.BorderSizePixel = 0
    chB = Instance.new("Frame", screenGui); chB.BackgroundColor3 = Color3.new(1,1,1); chB.BorderSizePixel = 0
end


local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer or not IsEnemy(player) then ClearESP(player); continue end
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if character and humanoid and humanoid.Health > 0 and rootPart then
            if not espObjects[player] then
                -- Main BillboardGui container
                local bg = Instance.new("BillboardGui")
                bg.Size = UDim2.new(0, 160, 0, 52)
                bg.StudsOffset = Vector3.new(0, 3.2, 0)
                bg.AlwaysOnTop = true
                -- Background panel
                local panel = Instance.new("Frame", bg)
                panel.Size = UDim2.new(1, 0, 1, 0)
                panel.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
                panel.BackgroundTransparency = 0.45
                panel.BorderSizePixel = 0
                Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 6)
                local panelStroke = Instance.new("UIStroke", panel)
                panelStroke.Thickness = 1; panelStroke.Transparency = 0.5
                -- Accent line top
                local accent = Instance.new("Frame", panel)
                accent.Size = UDim2.new(1, 0, 0, 2); accent.Position = UDim2.new(0, 0, 0, 0)
                accent.BackgroundTransparency = 0; accent.BorderSizePixel = 0
                Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 6)
                -- Name label
                local nameL = Instance.new("TextLabel", panel)
                nameL.Size = UDim2.new(1, -8, 0, 16); nameL.Position = UDim2.new(0, 4, 0, 4)
                nameL.BackgroundTransparency = 1; nameL.Font = Enum.Font.GothamBold; nameL.TextSize = 12
                nameL.TextStrokeTransparency = 0.4; nameL.TextXAlignment = Enum.TextXAlignment.Left
                -- Distance label
                local distL = Instance.new("TextLabel", panel)
                distL.Size = UDim2.new(1, -8, 0, 12); distL.Position = UDim2.new(0, 4, 0, 20)
                distL.BackgroundTransparency = 1; distL.Font = Enum.Font.GothamSemibold; distL.TextSize = 10
                distL.TextStrokeTransparency = 0.5; distL.TextXAlignment = Enum.TextXAlignment.Left
                distL.TextColor3 = Color3.fromRGB(180, 180, 200)
                -- HP bar background
                local hpBg = Instance.new("Frame", panel)
                hpBg.Size = UDim2.new(1, -8, 0, 5); hpBg.Position = UDim2.new(0, 4, 0, 35)
                hpBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40); hpBg.BackgroundTransparency = 0.3; hpBg.BorderSizePixel = 0
                Instance.new("UICorner", hpBg).CornerRadius = UDim.new(1, 0)
                -- HP bar fill
                local hpFill = Instance.new("Frame", hpBg)
                hpFill.Size = UDim2.new(1, 0, 1, 0)
                hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100); hpFill.BorderSizePixel = 0
                Instance.new("UICorner", hpFill).CornerRadius = UDim.new(1, 0)
                -- HP text
                local hpText = Instance.new("TextLabel", hpBg)
                hpText.Size = UDim2.new(1, 0, 1, 8); hpText.Position = UDim2.new(0, 0, 0, -1)
                hpText.BackgroundTransparency = 1; hpText.Font = Enum.Font.GothamBold; hpText.TextSize = 8
                hpText.TextColor3 = Color3.new(1,1,1); hpText.TextStrokeTransparency = 0.3
                -- Highlight
                local hl = Instance.new("Highlight"); hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                -- Glow Highlight (separate, for Neon glow effect)
                local glow = Instance.new("Highlight"); glow.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                glow.FillTransparency = 0.7; glow.OutlineTransparency = 0
                espObjects[player] = { bg = bg, panel = panel, panelStroke = panelStroke, accent = accent, nameL = nameL, distL = distL, hpBg = hpBg, hpFill = hpFill, hpText = hpText, hl = hl, glow = glow }
            end
            local data = espObjects[player]
            local isVisible = isVisibleCache[player] or false
            local col = isVisible and Settings.ESP.VisibleColor or Settings.ESP.HiddenColor

            -- Determine what to show
            local showAnything = Settings.ESP.Enabled and (Settings.ESP.ShowName or Settings.ESP.ShowHP or Settings.ESP.ShowDistance)
            local showName = Settings.ESP.Enabled and Settings.ESP.ShowName
            local showHP = Settings.ESP.Enabled and Settings.ESP.ShowHP
            local showDist = Settings.ESP.Enabled and Settings.ESP.ShowDistance

            -- Dynamic panel height
            local panelH = 6
            if showName then panelH = panelH + 16 end
            if showDist then panelH = panelH + 14 end
            if showHP then panelH = panelH + 10 end
            data.bg.Size = UDim2.new(0, 160, 0, panelH)

            -- Accent / stroke color
            data.accent.BackgroundColor3 = col
            data.panelStroke.Color = col

            -- Positioning elements dynamically
            local yOff = 4
            -- Name
            if showName then
                data.nameL.Visible = true
                data.nameL.Position = UDim2.new(0, 4, 0, yOff)
                data.nameL.Text = player.DisplayName ~= player.Name and (player.DisplayName .. "  ·  " .. player.Name) or player.Name
                data.nameL.TextColor3 = col
                yOff = yOff + 16
            else data.nameL.Visible = false end
            -- Distance
            if showDist then
                data.distL.Visible = true
                data.distL.Position = UDim2.new(0, 4, 0, yOff)
                local dist = math.floor((Camera.CFrame.Position - rootPart.Position).Magnitude)
                data.distL.Text = "📏 " .. dist .. " m"
                yOff = yOff + 14
            else data.distL.Visible = false end
            -- HP bar
            if showHP then
                data.hpBg.Visible = true
                data.hpBg.Position = UDim2.new(0, 4, 0, yOff)
                local hpFrac = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                data.hpFill.Size = UDim2.new(hpFrac, 0, 1, 0)
                -- HP bar color: green -> yellow -> red
                local hpColor
                if hpFrac > 0.5 then hpColor = Color3.fromRGB(math.floor((1 - hpFrac) * 2 * 255), 255, 50)
                else hpColor = Color3.fromRGB(255, math.floor(hpFrac * 2 * 255), 50) end
                data.hpFill.BackgroundColor3 = hpColor
                data.hpText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                data.hpText.Visible = true
                yOff = yOff + 10
            else data.hpBg.Visible = false; data.hpText.Visible = false end

            if showAnything then
                data.bg.Parent = rootPart; data.bg.Enabled = true; data.panel.Visible = true
            else data.bg.Parent = nil; data.bg.Enabled = false end

            -- Chams (only if ESP is on)
            if Settings.ESP.Chams and Settings.ESP.Enabled then
                local chamsCol = col
                if Settings.ESP.RainbowChams then chamsCol = Color3.fromHSV(rainbowHue, 1, 1) end
                data.hl.Parent = character; data.hl.FillColor = chamsCol; data.hl.OutlineColor = chamsCol; data.hl.FillTransparency = 0.5; data.hl.OutlineTransparency = 0
            else data.hl.Parent = nil end

            -- Glow Effect
            if Settings.ESP.GlowEffect and Settings.ESP.Enabled then
                local glowCol = Settings.ESP.RainbowChams and Color3.fromHSV(rainbowHue, 1, 1) or col
                data.glow.Parent = character; data.glow.FillColor = glowCol; data.glow.OutlineColor = glowCol; data.glow.FillTransparency = 0.85; data.glow.OutlineTransparency = 0.2
            else data.glow.Parent = nil end

            -- Tracers
            if Settings.ESP.Tracers and Settings.ESP.Enabled then
                local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    if supportDrawing then
                        if not data.tracer then data.tracer = Drawing.new("Line"); data.tracer.Thickness = 1.5; data.tracer.Transparency = 1 end
                        data.tracer.Visible = true; data.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); data.tracer.To = Vector2.new(pos.X, pos.Y); data.tracer.Color = col
                    else
                        if not data.tracerLine then local tl = Instance.new("Frame", screenGui); tl.BackgroundColor3 = col; tl.BorderSizePixel = 0; tl.AnchorPoint = Vector2.new(0.5, 0.5); data.tracerLine = tl end
                        local from = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); local to = Vector2.new(pos.X, pos.Y); local dstLine = (from - to).Magnitude
                        data.tracerLine.Size = UDim2.new(0, 2, 0, dstLine); data.tracerLine.Position = UDim2.new(0, (from.X + to.X) / 2, 0, (from.Y + to.Y) / 2); data.tracerLine.Rotation = math.deg(math.atan2(to.Y - from.Y, to.X - from.X)) + 90; data.tracerLine.Visible = true; data.tracerLine.BackgroundColor3 = col
                    end
                else if data.tracer then data.tracer.Visible = false end; if data.tracerLine then data.tracerLine.Visible = false end end
            else if data.tracer then data.tracer.Visible = false end; if data.tracerLine then data.tracerLine.Visible = false end end
        else ClearESP(player) end
    end
    if not Settings.ESP.Enabled then for p, _ in pairs(espObjects) do ClearESP(p) end end
end

-- Smart Aim: logic moved to background thread (smartAimCache)

local function GetClosestTarget()
    local maxDist = Settings.Aimbot.Radius
    local target, partToAim = nil, nil
    local mouseLoc = UserInputService:GetMouseLocation()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer or not IsEnemy(player) then continue end
        -- Check aimbot ignore list
        local ignored = false
        for _, ignoredName in ipairs(Settings.AimbotIgnoreList) do
            if player.Name == ignoredName or player.DisplayName == ignoredName then ignored = true; break end
        end
        if ignored then continue end
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local part
            if Settings.Aimbot.SmartAim and smartAimCache[player] then
                part = smartAimCache[player]
            else
                part = char:FindFirstChild(Settings.Aimbot.TargetPart)
                if part and Settings.Aimbot.WallCheck and not isVisibleCache[player] then part = nil end
            end
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mouseLoc).Magnitude
                    if dist < maxDist then maxDist, target, partToAim = dist, player, part end
                end
            end
        end
    end
    return target, partToAim
end

-- Tooltip UI System
local tooltipFrame = Instance.new("Frame", screenGui)
tooltipFrame.Name = "TooltipUI"
tooltipFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
tooltipFrame.BackgroundTransparency = 0.1
tooltipFrame.Active = false
tooltipFrame.Visible = false
tooltipFrame.ZIndex = 110
Instance.new("UICorner", tooltipFrame).CornerRadius = UDim.new(0, 6)
local tooltipStroke = Instance.new("UIStroke", tooltipFrame)
tooltipStroke.Color = Color3.fromRGB(0, 180, 255)
tooltipStroke.Transparency = 0.2
tooltipStroke.Thickness = 1
local tooltipTextLabel = Instance.new("TextLabel", tooltipFrame)
tooltipTextLabel.Size = UDim2.new(1, -10, 1, -10)
tooltipTextLabel.Position = UDim2.new(0, 5, 0, 5)
tooltipTextLabel.BackgroundTransparency = 1
tooltipTextLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
tooltipTextLabel.Font = Enum.Font.GothamMedium
tooltipTextLabel.TextSize = 11
tooltipTextLabel.TextWrapped = true
tooltipTextLabel.TextXAlignment = Enum.TextXAlignment.Left
tooltipTextLabel.TextYAlignment = Enum.TextYAlignment.Top
tooltipTextLabel.ZIndex = 111

local function ShowTooltip(text)
    if not text or text == "" then return end
    tooltipTextLabel.Text = text
    local bounds = game:GetService("TextService"):GetTextSize(text, 11, Enum.Font.GothamMedium, Vector2.new(200 - 10, 9999))
    tooltipFrame.Size = UDim2.new(0, 210, 0, bounds.Y + 14)
    local mouseLoc = UserInputService:GetMouseLocation()
    tooltipFrame.Position = UDim2.new(0, mouseLoc.X + 15, 0, mouseLoc.Y - 15)
    tooltipFrame.Visible = true
end

local function HideTooltip()
    tooltipFrame.Visible = false
end

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if tooltipFrame.Visible then
            local mouseLoc = input.Position
            tooltipFrame.Position = UDim2.new(0, mouseLoc.X + 15, 0, mouseLoc.Y - 15)
        end
    end
end)

-- // GUI INTERFACE (TABBED)

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 700, 0, 480)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 22)
mainFrame.BackgroundTransparency = 0.08
mainFrame.Active = true
MakeDraggable(mainFrame)
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
-- Adding drop shadow
local dropShadow = Instance.new("ImageLabel", mainFrame)
dropShadow.Size = UDim2.new(1, 40, 1, 40)
dropShadow.Position = UDim2.new(0, -20, 0, -20)
dropShadow.BackgroundTransparency = 1
dropShadow.Image = "rbxassetid://13192800336" -- A soft shadow decal 
dropShadow.ImageColor3 = Color3.new(0,0,0)
dropShadow.ImageTransparency = 0.4
dropShadow.ZIndex = -1
local mainStroke = Instance.new("UIStroke", mainFrame); mainStroke.Color = Color3.fromRGB(0, 180, 255); mainStroke.Transparency = 0.15; mainStroke.Thickness = 2
table.insert(RGBObjects, mainStroke)
local mainGrad = Instance.new("UIGradient", mainFrame)
mainGrad.Color = ColorSequence.new(Color3.fromRGB(10,10,28), Color3.fromRGB(5,5,16))
mainGrad.Rotation = 135

local header = Instance.new("TextLabel", mainFrame)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(10, 10, 28)
header.BackgroundTransparency = 0.1
header.Text = L("header")
header.TextColor3 = Color3.fromRGB(0, 230, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 14
header.TextXAlignment = Enum.TextXAlignment.Left
header.TextTransparency = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)
local headerGrad = Instance.new("UIGradient", header)
headerGrad.Color = ColorSequence.new(Color3.fromRGB(12,10,30), Color3.fromRGB(6,6,18))
headerGrad.Rotation = 90
local accentLine = Instance.new("Frame", header)
accentLine.Size = UDim2.new(1, 0, 0, 2)
accentLine.Position = UDim2.new(0, 0, 1, -1)
accentLine.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
accentLine.BackgroundTransparency = 0.1
accentLine.BorderSizePixel = 0

local leftMenu = Instance.new("Frame", mainFrame)
leftMenu.Size = UDim2.new(0, 150, 1, -45)
leftMenu.Position = UDim2.new(0, 5, 0, 40)
leftMenu.BackgroundColor3 = Color3.fromRGB(10, 10, 26)
leftMenu.BackgroundTransparency = 0.15
Instance.new("UICorner", leftMenu).CornerRadius = UDim.new(0, 8)
local leftStroke = Instance.new("UIStroke", leftMenu); leftStroke.Color = Color3.fromRGB(0, 150, 255); leftStroke.Transparency = 0.5; leftStroke.Thickness = 1.5
local leftLayout = Instance.new("UIListLayout", leftMenu); leftLayout.SortOrder = Enum.SortOrder.LayoutOrder; leftLayout.Padding = UDim.new(0, 4)

local rightContent = Instance.new("Frame", mainFrame)
rightContent.Size = UDim2.new(1, -165, 1, -45)
rightContent.Position = UDim2.new(0, 160, 0, 40)
rightContent.BackgroundTransparency = 1

local activeTab = nil
local tabs, contents = {}, {}

local function SelectTab(tabName)
    if activeTab == tabName then return end
    activeTab = tabName
    for name, btn in pairs(tabs) do
        local isActive = (name == tabName)
        TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = isActive and Color3.fromRGB(0, 60, 120) or Color3.fromRGB(12, 12, 30), BackgroundTransparency = isActive and 0.15 or 0.6}):Play()
        if contents[name] then
            contents[name].Visible = isActive
        end
    end
end

local tabOrder = 0
local function CreateTab(name)
    tabOrder = tabOrder + 1
    local btn = Instance.new("TextButton", leftMenu)
    btn.Size = UDim2.new(1, -8, 0, 34); btn.BackgroundColor3 = Color3.fromRGB(12, 12, 30); btn.BackgroundTransparency = 0.6; btn.TextColor3 = Color3.fromRGB(0, 200, 240); btn.Font = Enum.Font.GothamBold; btn.TextSize = 12; btn.Text = "  " .. name; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.LayoutOrder = tabOrder
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local st = Instance.new("UIStroke", btn); st.Color = Color3.fromRGB(0, 140, 220); st.Transparency = 0.7; st.Thickness = 1
    btn.MouseEnter:Connect(function() if activeTab ~= name then TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3, BackgroundColor3 = Color3.fromRGB(0, 40, 80)}):Play(); TweenService:Create(st, TweenInfo.new(0.15), {Transparency = 0.3, Color = Color3.fromRGB(0, 200, 255)}):Play() end end)
    btn.MouseLeave:Connect(function() if activeTab ~= name then TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.6, BackgroundColor3 = Color3.fromRGB(12, 12, 30)}):Play(); TweenService:Create(st, TweenInfo.new(0.15), {Transparency = 0.7, Color = Color3.fromRGB(0, 140, 220)}):Play() end end)
    tabs[name] = btn
    
    local scrollFrame = Instance.new("ScrollingFrame", rightContent)
    scrollFrame.Size = UDim2.new(1, 0, 1, 0); scrollFrame.BackgroundTransparency = 1; scrollFrame.ScrollBarThickness = 3; scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255); scrollFrame.Visible = false
    local layout = Instance.new("UIListLayout", scrollFrame); layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 5)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10) end)
    contents[name] = scrollFrame
    btn.MouseButton1Click:Connect(function() SelectTab(name) end)
    return scrollFrame
end

local function AddButton(parent, text, clickCallback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 34); btn.BackgroundColor3 = Color3.fromRGB(12, 12, 30); btn.BackgroundTransparency = 0.5; btn.TextColor3 = Color3.fromRGB(0, 220, 255); btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 12; btn.Text = text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local st = Instance.new("UIStroke", btn); st.Color = Color3.fromRGB(0, 140, 220); st.Transparency = 0.65; st.Thickness = 1
    btn.MouseEnter:Connect(function() 
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2, BackgroundColor3 = Color3.fromRGB(0, 40, 80)}):Play()
        TweenService:Create(st, TweenInfo.new(0.15), {Transparency = 0.2, Color = Color3.fromRGB(0, 220, 255)}):Play() 
        local baseT = string.split(text, ":")[1]
        local tTip = Tooltips[baseT] or Tooltips[text]
        if tTip then ShowTooltip(tTip) end
    end)
    btn.MouseLeave:Connect(function() 
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5, BackgroundColor3 = Color3.fromRGB(12, 12, 30)}):Play()
        TweenService:Create(st, TweenInfo.new(0.2), {Transparency = 0.65, Color = Color3.fromRGB(0, 140, 220)}):Play() 
        HideTooltip()
    end)
    local function UpdateCol(state) TweenService:Create(btn, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = state and Color3.fromRGB(0, 80, 160) or Color3.fromRGB(12, 12, 30)}):Play() end
    btn.MouseButton1Click:Connect(function() clickCallback(btn, UpdateCol) end)
end

local function AddSlider(parent, text, min, max, curr, callback)
    local frame = Instance.new("Frame", parent); frame.Size = UDim2.new(1, -10, 0, 45); frame.BackgroundColor3 = Color3.fromRGB(12, 12, 30); frame.BackgroundTransparency = 0.5; Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local st = Instance.new("UIStroke", frame); st.Color = Color3.fromRGB(0, 140, 220); st.Transparency = 0.65; st.Thickness = 1
    local lbl = Instance.new("TextLabel", frame); lbl.Size = UDim2.new(1, -10, 0, 20); lbl.Position = UDim2.new(0, 5, 0, 5); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(0, 220, 255); lbl.Text = text..": "..curr; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local back = Instance.new("Frame", frame); back.Size = UDim2.new(1, -10, 0, 8); back.Position = UDim2.new(0, 5, 0, 30); back.BackgroundColor3 = Color3.fromRGB(8, 8, 20); back.BackgroundTransparency = 0.2; Instance.new("UICorner", back).CornerRadius = UDim.new(1, 0)
    local posNorm = math.clamp((curr-min)/(max-min), 0, 1)
    if posNorm ~= posNorm then posNorm = 0 end
    local fill = Instance.new("Frame", back); fill.Size = UDim2.new(posNorm,0,1,0); fill.BackgroundColor3 = Color3.fromRGB(0, 160, 255); Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local fillGrad = Instance.new("UIGradient", fill); fillGrad.Color = ColorSequence.new(Color3.fromRGB(0, 100, 200), Color3.fromRGB(0, 220, 255)); fillGrad.Rotation = 0
    table.insert(RGBObjects, fill)
    local isD = false
    local function update(i) local pos = math.clamp((i.Position.X - back.AbsolutePosition.X) / back.AbsoluteSize.X, 0, 1); fill.Size = UDim2.new(pos, 0, 1, 0); local val = math.floor(min + (max - min) * pos); lbl.Text = text..": "..val; callback(val) end
    back.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then isD = true; update(i) end end)
    frame.MouseEnter:Connect(function()
        local tTip = Tooltips[text]
        if tTip then ShowTooltip(tTip) end
    end)
    frame.MouseLeave:Connect(function() HideTooltip() end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then isD = false end end)
    UserInputService.InputChanged:Connect(function(i) if isD and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end end)
end

-- // TARGET PLAYER WINDOW
local playerWindow = Instance.new("Frame", screenGui)
playerWindow.Size = UDim2.new(0, 260, 0, 380)
playerWindow.Position = UDim2.new(0.5, 270, 0.5, -190)
playerWindow.BackgroundColor3 = Color3.fromRGB(8, 8, 22)
playerWindow.BackgroundTransparency = 0.08
playerWindow.Active = true
MakeDraggable(playerWindow)
playerWindow.Visible = false
Instance.new("UICorner", playerWindow).CornerRadius = UDim.new(0, 10)
local pwStroke = Instance.new("UIStroke", playerWindow); pwStroke.Color = Color3.fromRGB(0, 180, 255); pwStroke.Transparency = 0.15; pwStroke.Thickness = 2
table.insert(RGBObjects, pwStroke)
local pwGrad = Instance.new("UIGradient", playerWindow)
pwGrad.Color = ColorSequence.new(Color3.fromRGB(10,10,28), Color3.fromRGB(5,5,16))
pwGrad.Rotation = 135

local pwHeader = Instance.new("TextLabel", playerWindow)
pwHeader.Size = UDim2.new(1, 0, 0, 35); pwHeader.BackgroundColor3 = Color3.fromRGB(10, 10, 28); pwHeader.BackgroundTransparency = 0.1; pwHeader.Text = L("players_header"); pwHeader.TextColor3 = Color3.fromRGB(0, 230, 255); pwHeader.Font = Enum.Font.GothamBold; pwHeader.TextSize = 13; pwHeader.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", pwHeader).CornerRadius = UDim.new(0, 10)
local pwHdrGrad = Instance.new("UIGradient", pwHeader)
pwHdrGrad.Color = ColorSequence.new(Color3.fromRGB(12,10,30), Color3.fromRGB(6,6,18))
pwHdrGrad.Rotation = 90
local pwAccent = Instance.new("Frame", pwHeader)
pwAccent.Size = UDim2.new(1, 0, 0, 2); pwAccent.Position = UDim2.new(0, 0, 1, -1)
pwAccent.BackgroundColor3 = Color3.fromRGB(0, 200, 255); pwAccent.BackgroundTransparency = 0.1; pwAccent.BorderSizePixel = 0

local closePwBtn = Instance.new("TextButton", pwHeader)
closePwBtn.Size = UDim2.new(0, 28, 0, 28); closePwBtn.Position = UDim2.new(1, -33, 0, 3); closePwBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 80); closePwBtn.BackgroundTransparency = 0.3; closePwBtn.Text = "X"; closePwBtn.TextColor3 = Color3.fromRGB(255, 200, 220); closePwBtn.Font = Enum.Font.GothamBold; closePwBtn.TextSize = 12
Instance.new("UICorner", closePwBtn).CornerRadius = UDim.new(0, 6)
closePwBtn.MouseEnter:Connect(function() TweenService:Create(closePwBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play() end)
closePwBtn.MouseLeave:Connect(function() TweenService:Create(closePwBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play() end)
closePwBtn.MouseButton1Click:Connect(function() playerWindow.Visible = false end)

local refBtn = Instance.new("TextButton", pwHeader)
refBtn.Size = UDim2.new(0, 28, 0, 28); refBtn.Position = UDim2.new(1, -66, 0, 3); refBtn.BackgroundColor3 = Color3.fromRGB(0, 50, 100); refBtn.BackgroundTransparency = 0.3; refBtn.Text = "↻"; refBtn.TextColor3 = Color3.fromRGB(0, 220, 255); refBtn.Font = Enum.Font.GothamBold; refBtn.TextSize = 14
Instance.new("UICorner", refBtn).CornerRadius = UDim.new(0, 6)
refBtn.MouseEnter:Connect(function() TweenService:Create(refBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play() end)
refBtn.MouseLeave:Connect(function() TweenService:Create(refBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play() end)

local plScroll = Instance.new("ScrollingFrame", playerWindow)
plScroll.Size = UDim2.new(1, -10, 1, -200); plScroll.Position = UDim2.new(0, 5, 0, 65); plScroll.BackgroundTransparency = 1; plScroll.ScrollBarThickness = 4
local plLayout = Instance.new("UIListLayout", plScroll); plLayout.SortOrder = Enum.SortOrder.LayoutOrder; plLayout.Padding = UDim.new(0, 4)
plLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() plScroll.CanvasSize = UDim2.new(0, 0, 0, plLayout.AbsoluteContentSize.Y + 5) end)

local actionPanel = Instance.new("Frame", playerWindow)
actionPanel.Size = UDim2.new(1, -10, 0, 120); actionPanel.Position = UDim2.new(0, 5, 1, -125); actionPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 26)
actionPanel.BackgroundTransparency = 0.3
Instance.new("UICorner", actionPanel).CornerRadius = UDim.new(0, 8)
local apStroke = Instance.new("UIStroke", actionPanel); apStroke.Color = Color3.fromRGB(0, 150, 255); apStroke.Transparency = 0.5; apStroke.Thickness = 1

local selName = Instance.new("TextLabel", actionPanel)

local searchBox = Instance.new("TextBox", actionPanel)
searchBox.Size = UDim2.new(1, -10, 0, 20); searchBox.Position = UDim2.new(0, 5, 0, 25)
searchBox.BackgroundColor3 = Color3.fromRGB(8, 8, 20); searchBox.BackgroundTransparency = 0.3
searchBox.TextColor3 = Color3.fromRGB(0, 220, 255); searchBox.PlaceholderText = L("search"); searchBox.PlaceholderColor3 = Color3.fromRGB(0, 100, 140)
searchBox.Font = Enum.Font.GothamSemibold; searchBox.TextSize = 10
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 5)
local sts = Instance.new("UIStroke", searchBox); sts.Color = Color3.fromRGB(0, 140, 220); sts.Transparency = 0.65; sts.Thickness = 1

selName.Size = UDim2.new(1, 0, 0, 20); selName.BackgroundTransparency = 1; selName.Text = L("selected") .. ": " .. L("selected_none"); selName.TextColor3 = Color3.fromRGB(0, 200, 255); selName.Font = Enum.Font.GothamBold; selName.TextSize = 11

local tempTarget = nil
local loopTpUIBtn = Instance.new("TextButton", actionPanel)
loopTpUIBtn.Size = UDim2.new(0.5, -5, 0, 30); loopTpUIBtn.Position = UDim2.new(0, 3, 0, 50); loopTpUIBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 30); loopTpUIBtn.BackgroundTransparency = 0.4; loopTpUIBtn.TextColor3 = Color3.fromRGB(0, 220, 255); loopTpUIBtn.Text = L("loop_tp") .. ": " .. L("off"); loopTpUIBtn.Font = Enum.Font.GothamSemibold; loopTpUIBtn.TextSize = 10; Instance.new("UICorner", loopTpUIBtn).CornerRadius = UDim.new(0, 5)
local st = Instance.new("UIStroke", loopTpUIBtn); st.Color = Color3.fromRGB(0, 140, 220); st.Transparency = 0.65; st.Thickness = 1

local spectateUIBtn = Instance.new("TextButton", actionPanel)
spectateUIBtn.Size = UDim2.new(0.5, -5, 0, 30); spectateUIBtn.Position = UDim2.new(0.5, 2, 0, 50); spectateUIBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 30); spectateUIBtn.BackgroundTransparency = 0.4; spectateUIBtn.TextColor3 = Color3.fromRGB(0, 220, 255); spectateUIBtn.Text = L("spectate"); spectateUIBtn.Font = Enum.Font.GothamSemibold; spectateUIBtn.TextSize = 10; Instance.new("UICorner", spectateUIBtn).CornerRadius = UDim.new(0, 5)
local st2 = Instance.new("UIStroke", spectateUIBtn); st2.Color = Color3.fromRGB(0, 140, 220); st2.Transparency = 0.65; st2.Thickness = 1

local tpOnceBtn = Instance.new("TextButton", actionPanel)
tpOnceBtn.Size = UDim2.new(1, -6, 0, 30); tpOnceBtn.Position = UDim2.new(0, 3, 0, 85); tpOnceBtn.BackgroundColor3 = Color3.fromRGB(0, 60, 140); tpOnceBtn.BackgroundTransparency = 0.2; tpOnceBtn.TextColor3 = Color3.fromRGB(180, 240, 255); tpOnceBtn.Text = L("tp_to"); tpOnceBtn.Font = Enum.Font.GothamSemibold; tpOnceBtn.TextSize = 11; Instance.new("UICorner", tpOnceBtn).CornerRadius = UDim.new(0, 5)
local st3 = Instance.new("UIStroke", tpOnceBtn); st3.Color = Color3.fromRGB(0, 180, 255); st3.Transparency = 0.3; st3.Thickness = 1

local function RefreshPlayerList(filter)
    for _, v in ipairs(plScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    local list = Players:GetPlayers()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    table.sort(list, function(a,b)
        if a == LocalPlayer then return false end
        if b == LocalPlayer then return true end
        if currentSortMode == "name" then return a.Name:lower() < b.Name:lower() end
        if not a.Character or not b.Character then return false end
        if currentSortMode == "hp" then
            local hA = a.Character:FindFirstChildOfClass("Humanoid")
            local hB = b.Character:FindFirstChildOfClass("Humanoid")
            return (hA and hA.Health or 0) < (hB and hB.Health or 0)
        end
        if currentSortMode == "visible" then
            local vA = isVisibleCache[a] and 1 or 0
            local vB = isVisibleCache[b] and 1 or 0
            if vA ~= vB then return vA > vB end
        end
        if not myRoot then return false end
        local rA = a.Character:FindFirstChild("HumanoidRootPart")
        local rB = b.Character:FindFirstChild("HumanoidRootPart")
        if not rA or not rB then return false end
        return (rA.Position - myRoot.Position).Magnitude < (rB.Position - myRoot.Position).Magnitude
    end)
    for _, p in ipairs(list) do
        if p == LocalPlayer then continue end
        if filter and filter ~= "" and not string.find(string.lower(p.Name), string.lower(filter)) then continue end
        local pBtn = Instance.new("TextButton", plScroll)
        pBtn.Size = UDim2.new(1, -4, 0, 26); pBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 30); pBtn.BackgroundTransparency = 0.4; pBtn.TextColor3 = Color3.fromRGB(0, 210, 255); pBtn.Text = "  " .. p.Name; pBtn.Font = Enum.Font.GothamSemibold; pBtn.TextSize = 11; pBtn.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 5)
        pBtn.MouseEnter:Connect(function() TweenService:Create(pBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0.15, BackgroundColor3 = Color3.fromRGB(0, 50, 100)}):Play() end)
        pBtn.MouseLeave:Connect(function() TweenService:Create(pBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0.4, BackgroundColor3 = Color3.fromRGB(12, 12, 30)}):Play() end)
        pBtn.MouseButton1Click:Connect(function()
            tempTarget = p
            selName.Text = L("selected") .. ": " .. p.Name
            if Settings.TP.TargetPlayer ~= p then
                Settings.TP.LoopTP = false
                loopTpUIBtn.Text = L("loop_tp") .. ": " .. L("off")
                loopTpUIBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 30)
                Settings.TP.TargetPlayer = nil
            end
        end)
    end
end
refBtn.MouseButton1Click:Connect(function() RefreshPlayerList(searchBox.Text) end)
searchBox.FocusLost:Connect(function() RefreshPlayerList(searchBox.Text) end)

-- Sort bar
local sortBar = Instance.new("Frame", playerWindow)
sortBar.Size = UDim2.new(1, -10, 0, 24); sortBar.Position = UDim2.new(0, 5, 0, 38)
sortBar.BackgroundTransparency = 1
local sortBarLayout = Instance.new("UIListLayout", sortBar)
sortBarLayout.FillDirection = Enum.FillDirection.Horizontal
sortBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sortBarLayout.Padding = UDim.new(0, 3)
local sortModes = {{"distance", L("sort_distance")}, {"name", L("sort_name")}, {"hp", L("sort_hp")}, {"visible", L("sort_visible")}}
local sortButtons = {}
for i, mode in ipairs(sortModes) do
    local sb = Instance.new("TextButton", sortBar)
    sb.Size = UDim2.new(0.25, -3, 1, 0)
    sb.BackgroundColor3 = (currentSortMode == mode[1]) and Color3.fromRGB(0, 80, 160) or Color3.fromRGB(10, 10, 26)
    sb.BackgroundTransparency = 0.3; sb.TextColor3 = Color3.fromRGB(0, 200, 240)
    sb.Font = Enum.Font.GothamSemibold; sb.TextSize = 9; sb.Text = mode[2]; sb.LayoutOrder = i
    Instance.new("UICorner", sb).CornerRadius = UDim.new(0, 4)
    sortButtons[mode[1]] = sb
    sb.MouseButton1Click:Connect(function()
        currentSortMode = mode[1]
        for k, v in pairs(sortButtons) do
            v.BackgroundColor3 = (k == mode[1]) and Color3.fromRGB(0, 80, 160) or Color3.fromRGB(10, 10, 26)
        end
        RefreshPlayerList(searchBox.Text)
    end)
end

tpOnceBtn.MouseButton1Click:Connect(function()
    if tempTarget and tempTarget.Character and tempTarget.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = tempTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)

spectateUIBtn.MouseButton1Click:Connect(function()
    if Settings.TP.Spectating then
        Settings.TP.Spectating = false
        Settings.TP.SpectateTarget = nil
        spectateUIBtn.Text = L("spectate")
        spectateUIBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 30)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    else
        if tempTarget then
            Settings.TP.Spectating = true
            Settings.TP.SpectateTarget = tempTarget
            spectateUIBtn.Text = L("spectate") .. ": " .. L("on")
            spectateUIBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 160)
            if tempTarget.Character and tempTarget.Character:FindFirstChildOfClass("Humanoid") then
                Camera.CameraSubject = tempTarget.Character:FindFirstChildOfClass("Humanoid")
            end
        end
    end
end)

loopTpUIBtn.MouseButton1Click:Connect(function()
    if not tempTarget then return end
    Settings.TP.LoopTP = not Settings.TP.LoopTP
    loopTpUIBtn.Text = L("loop_tp") .. ": " .. (Settings.TP.LoopTP and L("on") or L("off"))
    loopTpUIBtn.BackgroundColor3 = Settings.TP.LoopTP and Color3.fromRGB(0, 80, 160) or Color3.fromRGB(12, 12, 30)
    if Settings.TP.LoopTP then Settings.TP.TargetPlayer = tempTarget else Settings.TP.TargetPlayer = nil end
end)


-- MENU
local tabVisuals = CreateTab(L("tab_visuals"))
local tabCombat = CreateTab(L("tab_combat"))
local tabMovement = CreateTab(L("tab_movement"))
local tabWorld = CreateTab(L("tab_world"))
local tabRage = CreateTab(L("tab_rage"))
local tabProtection = CreateTab(L("tab_protection"))
local tabMisc = CreateTab(L("tab_settings"))
local tabBinds = CreateTab(L("tab_binds"))
local tabTheme = CreateTab(L("tab_theme"))

-- Apply Theme function
local function ApplyTheme(name)
    local t = Themes[name]
    if not t then return end
    Settings.Theme.Current = name
    mainFrame.BackgroundColor3 = t.bg
    mainStroke.Color = t.accent
    mainGrad.Color = ColorSequence.new(t.grad1, t.grad2)
    header.BackgroundColor3 = t.header
    accentLine.BackgroundColor3 = t.accent
    leftMenu.BackgroundColor3 = t.leftMenu
    pwStroke.Color = t.accent
    pwHeader.BackgroundColor3 = t.header
    pwAccent.BackgroundColor3 = t.accent
    playerWindow.BackgroundColor3 = t.bg
    SendNotify(string.format(L("notify_theme"), name))
end

-- Bind button helper
local function AddBindButton(parent, label, bindKey)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 34); btn.BackgroundColor3 = Color3.fromRGB(12, 12, 30); btn.BackgroundTransparency = 0.5
    btn.TextColor3 = Color3.fromRGB(0, 220, 255); btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 12
    btn.Text = label .. ": " .. UserBinds[bindKey].Name
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local bst = Instance.new("UIStroke", btn); bst.Color = Color3.fromRGB(0, 140, 220); bst.Transparency = 0.65; bst.Thickness = 1
    btn.MouseEnter:Connect(function() 
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play()
        local tTip = Tooltips[label]
        if tTip then ShowTooltip(tTip) end
    end)
    btn.MouseLeave:Connect(function() 
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() 
        HideTooltip()
    end)
    btn.MouseButton1Click:Connect(function()
        if listeningBind then return end
        listeningBind = {btn = btn, key = bindKey, label = label}
        btn.Text = L("bind_press_key")
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 80, 0)}):Play()
    end)
end

AddButton(tabMisc, L("rejoin"), function(b,c)
    SendNotify(L("notify_rejoin"))
    task.delay(2, function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end)
AddButton(tabMisc, L("server_hop"), function(b,c)
    SendNotify(L("notify_search_server"))
    local success, servers = pcall(function()
        local Http = game:GetService("HttpService")
        local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        return Http:JSONDecode(game:HttpGet(url))
    end)
    if success and servers and servers.data then
        for _, s in ipairs(servers.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                return
            end
        end
        SendNotify(L("notify_no_server"))
    else
        SendNotify(L("notify_server_error"))
    end
end)
AddButton(tabMisc, L("hide_menu"), function(b,c) 
    mainFrame.Visible = false
    playerWindow.Visible = false
    Settings.ESP.Enabled = false
    Settings.Aimbot.Enabled = false
    c(true)
end)
AddButton(tabMisc, L("anti_afk") .. ": " .. L("on"), function(b,c) Settings.Config.AntiAFK = not Settings.Config.AntiAFK; b.Text = L("anti_afk") .. ": " .. (Settings.Config.AntiAFK and L("on") or L("off")); c(Settings.Config.AntiAFK) end)
AddButton(tabMisc, L("team_check") .. ": " .. L("off"), function(b,c) Settings.Misc.TeamCheck = not Settings.Misc.TeamCheck; b.Text = L("team_check") .. ": " .. (Settings.Misc.TeamCheck and L("on") or L("off")); c(Settings.Misc.TeamCheck)
    if Settings.Misc.TeamCheck then SendNotify(L("notify_team_on")) else SendNotify(L("notify_team_off")) end
end)
AddButton(tabMisc, L("save_config"), function(b,c) 
    if writefile then 
        writefile("Rivals_Premium_Cfg.json", HttpService:JSONEncode(Settings))
        b.Text = L("saved")
        task.wait(1)
        b.Text = L("save_config")
    end
    c(true) 
end)

AddButton(tabMisc, L("load_config"), function(b,c) 
    if readfile and isfile and isfile("Rivals_Premium_Cfg.json") then 
        local s, r = pcall(function() return HttpService:JSONDecode(readfile("Rivals_Premium_Cfg.json")) end)
        if s and r then Settings = r; b.Text = L("loaded") end
        task.wait(1)
        b.Text = L("load_config")
    end
    c(true) 
end)

AddButton(tabVisuals, L("esp_main") .. ": " .. L("off"), function(b,c) Settings.ESP.Enabled = not Settings.ESP.Enabled; b.Text = L("esp_main") .. ": " .. (Settings.ESP.Enabled and L("on") or L("off")); c(Settings.ESP.Enabled)
    if Settings.ESP.Enabled then SendNotify(L("notify_esp_on")) else SendNotify(L("notify_esp_off")) end
    if not Settings.ESP.Enabled then Settings.ESP.Chams = false; Settings.ESP.Tracers = false end
end)
AddButton(tabVisuals, L("esp_names") .. ": " .. L("off"), function(b,c) Settings.ESP.ShowName = not Settings.ESP.ShowName; b.Text = L("esp_names") .. ": " .. (Settings.ESP.ShowName and L("on") or L("off")); c(Settings.ESP.ShowName) end)
AddButton(tabVisuals, L("esp_distance") .. ": " .. L("off"), function(b,c) Settings.ESP.ShowDistance = not Settings.ESP.ShowDistance; b.Text = L("esp_distance") .. ": " .. (Settings.ESP.ShowDistance and L("on") or L("off")); c(Settings.ESP.ShowDistance) end)
AddButton(tabVisuals, L("esp_hp") .. ": " .. L("off"), function(b,c) Settings.ESP.ShowHP = not Settings.ESP.ShowHP; b.Text = L("esp_hp") .. ": " .. (Settings.ESP.ShowHP and L("on") or L("off")); c(Settings.ESP.ShowHP) end)
AddButton(tabVisuals, L("esp_chams") .. ": " .. L("off"), function(b,c)
    if not Settings.ESP.Enabled then SendNotify(L("notify_esp_first")); return end
    Settings.ESP.Chams = not Settings.ESP.Chams; b.Text = L("esp_chams") .. ": " .. (Settings.ESP.Chams and L("on") or L("off")); c(Settings.ESP.Chams)
end)
AddButton(tabVisuals, L("esp_tracers") .. ": " .. L("off"), function(b,c)
    if not Settings.ESP.Enabled then SendNotify(L("notify_esp_first")); return end
    Settings.ESP.Tracers = not Settings.ESP.Tracers; b.Text = L("esp_tracers") .. ": " .. (Settings.ESP.Tracers and L("on") or L("off")); c(Settings.ESP.Tracers)
end)
AddButton(tabVisuals, L("show_fov") .. ": " .. L("on"), function(b,c) Settings.Aimbot.ShowFOV = not Settings.Aimbot.ShowFOV; b.Text = L("show_fov") .. ": " .. (Settings.Aimbot.ShowFOV and L("on") or L("off")); c(Settings.Aimbot.ShowFOV) end)
AddButton(tabVisuals, L("glow_effect") .. ": " .. L("off"), function(b,c)
    if not Settings.ESP.Enabled then SendNotify(L("notify_esp_first")); return end
    Settings.ESP.GlowEffect = not Settings.ESP.GlowEffect; b.Text = L("glow_effect") .. ": " .. (Settings.ESP.GlowEffect and L("on") or L("off")); c(Settings.ESP.GlowEffect)
end)
AddButton(tabVisuals, L("rainbow_chams") .. ": " .. L("off"), function(b,c) Settings.ESP.RainbowChams = not Settings.ESP.RainbowChams; b.Text = L("rainbow_chams") .. ": " .. (Settings.ESP.RainbowChams and L("on") or L("off")); c(Settings.ESP.RainbowChams) end)
AddButton(tabVisuals, L("dmg_indicator") .. ": " .. L("off"), function(b,c) Settings.ESP.DmgIndicator = not Settings.ESP.DmgIndicator; b.Text = L("dmg_indicator") .. ": " .. (Settings.ESP.DmgIndicator and L("on") or L("off")); c(Settings.ESP.DmgIndicator) end)
AddButton(tabVisuals, L("crosshair") .. ": " .. L("off"), function(b,c) Settings.ESP.Crosshair = not Settings.ESP.Crosshair; b.Text = L("crosshair") .. ": " .. (Settings.ESP.Crosshair and L("on") or L("off")); c(Settings.ESP.Crosshair) end)
AddSlider(tabVisuals, L("crosshair_size"), 2, 30, 8, function(v) Settings.ESP.CrosshairSize = v end)
AddButton(tabVisuals, L("box_esp") .. ": " .. L("off"), function(b,c) Settings.ESP.BoxESP = not Settings.ESP.BoxESP; b.Text = L("box_esp") .. ": " .. (Settings.ESP.BoxESP and L("on") or L("off")); c(Settings.ESP.BoxESP) end)
AddButton(tabVisuals, L("skeleton_esp") .. ": " .. L("off"), function(b,c) Settings.ESP.SkeletonESP = not Settings.ESP.SkeletonESP; b.Text = L("skeleton_esp") .. ": " .. (Settings.ESP.SkeletonESP and L("on") or L("off")); c(Settings.ESP.SkeletonESP) end)
AddButton(tabVisuals, L("head_dot") .. ": " .. L("off"), function(b,c) Settings.ESP.HeadDot = not Settings.ESP.HeadDot; b.Text = L("head_dot") .. ": " .. (Settings.ESP.HeadDot and L("on") or L("off")); c(Settings.ESP.HeadDot) end)
AddButton(tabVisuals, L("snap_lines") .. ": " .. L("off"), function(b,c) Settings.ESP.SnapLines = not Settings.ESP.SnapLines; b.Text = L("snap_lines") .. ": " .. (Settings.ESP.SnapLines and L("on") or L("off")); c(Settings.ESP.SnapLines) end)
AddButton(tabVisuals, L("view_angles") .. ": " .. L("off"), function(b,c) Settings.ESP.ViewAngles = not Settings.ESP.ViewAngles; b.Text = L("view_angles") .. ": " .. (Settings.ESP.ViewAngles and L("on") or L("off")); c(Settings.ESP.ViewAngles) end)
AddButton(tabVisuals, L("proximity_warn") .. ": " .. L("off"), function(b,c) Settings.ESP.ProximityWarn = not Settings.ESP.ProximityWarn; b.Text = L("proximity_warn") .. ": " .. (Settings.ESP.ProximityWarn and L("on") or L("off")); c(Settings.ESP.ProximityWarn) end)
AddSlider(tabVisuals, L("proximity_dist"), 5, 100, 30, function(v) Settings.ESP.ProximityDist = v end)
AddButton(tabVisuals, L("night_vision") .. ": " .. L("off"), function(b,c) Settings.ESP.NightVision = not Settings.ESP.NightVision; b.Text = L("night_vision") .. ": " .. (Settings.ESP.NightVision and L("on") or L("off")); c(Settings.ESP.NightVision) end)
AddButton(tabVisuals, L("third_person") .. ": " .. L("off"), function(b,c) 
    Settings.ESP.ThirdPerson = not Settings.ESP.ThirdPerson; 
    b.Text = L("third_person") .. ": " .. (Settings.ESP.ThirdPerson and L("on") or L("off")); 
    c(Settings.ESP.ThirdPerson) 
    if not Settings.ESP.ThirdPerson then
        pcall(function() LocalPlayer.CameraMaxZoomDistance = 400; LocalPlayer.CameraMinZoomDistance = 0.5 end)
    end
end)
AddSlider(tabVisuals, L("third_person_dist"), 5, 30, 10, function(v) Settings.ESP.ThirdPersonDist = v end)
AddButton(tabVisuals, L("freecam") .. ": " .. L("off"), function(b,c) Settings.ESP.Freecam = not Settings.ESP.Freecam; b.Text = L("freecam") .. ": " .. (Settings.ESP.Freecam and L("on") or L("off")); c(Settings.ESP.Freecam) end)
AddButton(tabVisuals, L("no_fog") .. ": " .. L("off"), function(b,c) Settings.ESP.NoFog = not Settings.ESP.NoFog; b.Text = L("no_fog") .. ": " .. (Settings.ESP.NoFog and L("on") or L("off")); c(Settings.ESP.NoFog) end)
AddButton(tabVisuals, L("no_shadows") .. ": " .. L("off"), function(b,c) Settings.ESP.NoShadows = not Settings.ESP.NoShadows; b.Text = L("no_shadows") .. ": " .. (Settings.ESP.NoShadows and L("on") or L("off")); c(Settings.ESP.NoShadows) end)
AddButton(tabVisuals, L("fov_circle_color"), function(b,c) Settings.ESP.FOVCircleColor = (Settings.ESP.FOVCircleColor % 6) + 1; local colors = {"White","Cyan","Red","Green","Yellow","Magenta"}; b.Text = L("fov_circle_color") .. ": " .. colors[Settings.ESP.FOVCircleColor]; c(true) end)
AddButton(tabVisuals, L("bright_players") .. ": " .. L("off"), function(b,c) Settings.ESP.BrightPlayers = not Settings.ESP.BrightPlayers; b.Text = L("bright_players") .. ": " .. (Settings.ESP.BrightPlayers and L("on") or L("off")); c(Settings.ESP.BrightPlayers) end)
AddButton(tabVisuals, L("weapon_esp") .. ": " .. L("off"), function(b,c) Settings.ESP.WeaponESP = not Settings.ESP.WeaponESP; b.Text = L("weapon_esp") .. ": " .. (Settings.ESP.WeaponESP and L("on") or L("off")); c(Settings.ESP.WeaponESP) end)
AddSlider(tabVisuals, L("nameplate_size"), 1, 3, 1, function(v) Settings.ESP.NameplateSize = v end)
AddButton(tabVisuals, L("target_indicator") .. ": " .. L("off"), function(b,c) Settings.ESP.TargetIndicator = not Settings.ESP.TargetIndicator; b.Text = L("target_indicator") .. ": " .. (Settings.ESP.TargetIndicator and L("on") or L("off")); c(Settings.ESP.TargetIndicator) end)
AddButton(tabVisuals, L("kill_counter") .. ": " .. L("off"), function(b,c) Settings.ESP.KillCounter = not Settings.ESP.KillCounter; b.Text = L("kill_counter") .. ": " .. (Settings.ESP.KillCounter and L("on") or L("off")); c(Settings.ESP.KillCounter) end)

-- EXTRA VISUALS
AddButton(tabVisuals, L("bullet_tracers") .. ": " .. L("off"), function(b,c) Settings.ESP.BulletTracers = not Settings.ESP.BulletTracers; b.Text = L("bullet_tracers") .. ": " .. (Settings.ESP.BulletTracers and L("on") or L("off")); c(Settings.ESP.BulletTracers) end)
AddButton(tabVisuals, L("off_screen_arrows") .. ": " .. L("off"), function(b,c) Settings.ESP.OffScreenArrows = not Settings.ESP.OffScreenArrows; b.Text = L("off_screen_arrows") .. ": " .. (Settings.ESP.OffScreenArrows and L("on") or L("off")); c(Settings.ESP.OffScreenArrows) end)
AddButton(tabVisuals, L("item_esp") .. ": " .. L("off"), function(b,c) Settings.ESP.ItemESP = not Settings.ESP.ItemESP; b.Text = L("item_esp") .. ": " .. (Settings.ESP.ItemESP and L("on") or L("off")); c(Settings.ESP.ItemESP) end)
AddButton(tabVisuals, L("target_highlight") .. ": " .. L("off"), function(b,c) Settings.ESP.TargetHighlight = not Settings.ESP.TargetHighlight; b.Text = L("target_highlight") .. ": " .. (Settings.ESP.TargetHighlight and L("on") or L("off")); c(Settings.ESP.TargetHighlight) end)
AddButton(tabVisuals, L("spectator_list") .. ": " .. L("off"), function(b,c) Settings.ESP.SpectatorList = not Settings.ESP.SpectatorList; b.Text = L("spectator_list") .. ": " .. (Settings.ESP.SpectatorList and L("on") or L("off")); c(Settings.ESP.SpectatorList) end)

AddButton(tabCombat, L("aimbot") .. ": " .. L("off"), function(b,c) Settings.Aimbot.Enabled = not Settings.Aimbot.Enabled; b.Text = L("aimbot") .. ": " .. (Settings.Aimbot.Enabled and L("on") or L("off")); c(Settings.Aimbot.Enabled) end)
AddButton(tabCombat, L("silent_aim") .. ": " .. L("off"), function(b,c) Settings.Aimbot.SilentAim = not Settings.Aimbot.SilentAim; b.Text = L("silent_aim") .. ": " .. (Settings.Aimbot.SilentAim and L("on") or L("off")); c(Settings.Aimbot.SilentAim)
    if Settings.Aimbot.SilentAim then SendNotify(L("notify_silent")) end
end)
AddButton(tabCombat, L("no_recoil") .. ": " .. L("off"), function(b,c) Settings.Combat.NoRecoil = not Settings.Combat.NoRecoil; b.Text = L("no_recoil") .. ": " .. (Settings.Combat.NoRecoil and L("on") or L("off")); c(Settings.Combat.NoRecoil) end)
AddButton(tabCombat, L("triggerbot") .. ": " .. L("off"), function(b,c) Settings.Combat.TriggerBot = not Settings.Combat.TriggerBot; b.Text = L("triggerbot") .. ": " .. (Settings.Combat.TriggerBot and L("on") or L("off")); c(Settings.Combat.TriggerBot) end)
AddButton(tabCombat, L("wallcheck") .. ": " .. L("off"), function(b,c) Settings.Aimbot.WallCheck = not Settings.Aimbot.WallCheck; b.Text = L("wallcheck") .. ": " .. (Settings.Aimbot.WallCheck and L("on") or L("off")); c(Settings.Aimbot.WallCheck)
    if Settings.Aimbot.WallCheck then SendNotify(L("notify_wallcheck")) end
end)
AddButton(tabCombat, L("aim_target") .. ": " .. L("aim_target_head"), function(b,c) 
    if Settings.Aimbot.TargetPart == "Head" then Settings.Aimbot.TargetPart = "HumanoidRootPart"; b.Text = L("aim_target") .. ": " .. L("aim_target_body") else Settings.Aimbot.TargetPart = "Head"; b.Text = L("aim_target") .. ": " .. L("aim_target_head") end; c(true)
end)
AddSlider(tabCombat, L("aim_speed"), 1, 50, 5, function(v) Settings.Aimbot.Smoothing = v end)
AddSlider(tabCombat, L("aim_fov"), 10, 1000, 150, function(v) Settings.Aimbot.Radius = v end)
AddButton(tabCombat, L("prediction") .. ": " .. L("off"), function(b,c) Settings.Aimbot.Prediction = not Settings.Aimbot.Prediction; b.Text = L("prediction") .. ": " .. (Settings.Aimbot.Prediction and L("on") or L("off")); c(Settings.Aimbot.Prediction) end)
AddSlider(tabCombat, L("predict_power"), 1, 100, 15, function(v) Settings.Aimbot.PredictFactor = v / 100 end)
AddButton(tabCombat, L("smart_aim") .. ": " .. L("off"), function(b,c)
    Settings.Aimbot.SmartAim = not Settings.Aimbot.SmartAim
    b.Text = L("smart_aim") .. ": " .. (Settings.Aimbot.SmartAim and L("on") or L("off"))
    c(Settings.Aimbot.SmartAim)
    if Settings.Aimbot.SmartAim then SendNotify(L("notify_smart_aim")) end
end)
AddButton(tabCombat, L("hitbox") .. ": " .. L("off"), function(b,c) Settings.Hitbox.Enabled = not Settings.Hitbox.Enabled; b.Text = L("hitbox") .. ": " .. (Settings.Hitbox.Enabled and L("on") or L("off")); c(Settings.Hitbox.Enabled) end)
AddSlider(tabCombat, L("hitbox_size"), 1, 1000, 6, function(v) Settings.Hitbox.Size = v end)
AddButton(tabCombat, L("hitbox_prox_shrink") .. ": " .. L("off"), function(b,c) Settings.Hitbox.ProximityShrink = not Settings.Hitbox.ProximityShrink; b.Text = L("hitbox_prox_shrink") .. ": " .. (Settings.Hitbox.ProximityShrink and L("on") or L("off")); c(Settings.Hitbox.ProximityShrink) end)
AddSlider(tabCombat, L("hitbox_shrink_dist"), 5, 100, 25, function(v) Settings.Hitbox.ShrinkDist = v end)
AddButton(tabCombat, L("hitbox_entity") .. ": " .. L("off"), function(b,c) Settings.Hitbox.EntityHitbox = not Settings.Hitbox.EntityHitbox; b.Text = L("hitbox_entity") .. ": " .. (Settings.Hitbox.EntityHitbox and L("on") or L("off")); c(Settings.Hitbox.EntityHitbox) end)
AddSlider(tabCombat, L("hitbox_entity_size"), 1, 1000, 8, function(v) Settings.Hitbox.EntitySize = v end)
AddButton(tabCombat, L("hitbox_expand_all") .. ": " .. L("on"), function(b,c) Settings.Hitbox.ExpandAllParts = not Settings.Hitbox.ExpandAllParts; b.Text = L("hitbox_expand_all") .. ": " .. (Settings.Hitbox.ExpandAllParts and L("on") or L("off")); c(Settings.Hitbox.ExpandAllParts) end)

-- ===== AIMBOT IGNORE LIST (Dropdown) =====
do
    local ignoreFrame = Instance.new("Frame", tabCombat)
    ignoreFrame.Size = UDim2.new(1, -10, 0, 34); ignoreFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 30); ignoreFrame.BackgroundTransparency = 0.5
    Instance.new("UICorner", ignoreFrame).CornerRadius = UDim.new(0, 6)
    local igSt = Instance.new("UIStroke", ignoreFrame); igSt.Color = Color3.fromRGB(0, 140, 220); igSt.Transparency = 0.65; igSt.Thickness = 1
    local igLabel = Instance.new("TextLabel", ignoreFrame)
    igLabel.Size = UDim2.new(1, -10, 1, 0); igLabel.Position = UDim2.new(0, 5, 0, 0); igLabel.BackgroundTransparency = 1
    igLabel.TextColor3 = Color3.fromRGB(0, 220, 255); igLabel.Font = Enum.Font.GothamSemibold; igLabel.TextSize = 12
    igLabel.Text = L("aimbot_ignore") .. " [▼]"; igLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ignoreDropdown = Instance.new("Frame", tabCombat)
    ignoreDropdown.Size = UDim2.new(1, -10, 0, 0); ignoreDropdown.BackgroundColor3 = Color3.fromRGB(8, 8, 20); ignoreDropdown.BackgroundTransparency = 0.3
    ignoreDropdown.ClipsDescendants = true; ignoreDropdown.Visible = false
    Instance.new("UICorner", ignoreDropdown).CornerRadius = UDim.new(0, 6)
    local igDropLayout = Instance.new("UIListLayout", ignoreDropdown); igDropLayout.SortOrder = Enum.SortOrder.LayoutOrder; igDropLayout.Padding = UDim.new(0, 2)
    
    local ignoreDropdownOpen = false
    
    local function RefreshIgnoreDropdown()
        for _, child in ipairs(ignoreDropdown:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        -- Show currently ignored players with remove button
        for i, name in ipairs(Settings.AimbotIgnoreList) do
            local row = Instance.new("TextButton", ignoreDropdown)
            row.Size = UDim2.new(1, 0, 0, 26); row.BackgroundColor3 = Color3.fromRGB(60, 15, 15); row.BackgroundTransparency = 0.4
            row.TextColor3 = Color3.fromRGB(255, 120, 120); row.Font = Enum.Font.GothamSemibold; row.TextSize = 11
            row.Text = "✖ " .. name; row.LayoutOrder = i
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)
            row.MouseButton1Click:Connect(function()
                table.remove(Settings.AimbotIgnoreList, i)
                SendNotify("✅ " .. name .. " убран из игнора аимбота")
                RefreshIgnoreDropdown()
            end)
        end
        -- Show all other players with add button
        local orderIdx = #Settings.AimbotIgnoreList + 1
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            local alreadyIgnored = false
            for _, name in ipairs(Settings.AimbotIgnoreList) do
                if player.Name == name then alreadyIgnored = true; break end
            end
            if not alreadyIgnored then
                local row = Instance.new("TextButton", ignoreDropdown)
                row.Size = UDim2.new(1, 0, 0, 26); row.BackgroundColor3 = Color3.fromRGB(12, 30, 12); row.BackgroundTransparency = 0.4
                row.TextColor3 = Color3.fromRGB(120, 255, 120); row.Font = Enum.Font.GothamSemibold; row.TextSize = 11
                row.Text = "+ " .. player.DisplayName .. " (" .. player.Name .. ")"; row.LayoutOrder = orderIdx
                orderIdx = orderIdx + 1
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)
                local pName = player.Name
                row.MouseButton1Click:Connect(function()
                    table.insert(Settings.AimbotIgnoreList, pName)
                    SendNotify("⛔ " .. pName .. " добавлен в игнор аимбота")
                    RefreshIgnoreDropdown()
                end)
            end
        end
        -- Resize dropdown
        local totalItems = 0
        for _, child in ipairs(ignoreDropdown:GetChildren()) do if child:IsA("TextButton") then totalItems = totalItems + 1 end end
        local height = math.min(totalItems * 28, 200)
        ignoreDropdown.Size = UDim2.new(1, -10, 0, height)
    end
    
    ignoreFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            ignoreDropdownOpen = not ignoreDropdownOpen
            if ignoreDropdownOpen then
                RefreshIgnoreDropdown()
                ignoreDropdown.Visible = true
                igLabel.Text = L("aimbot_ignore") .. " [▲]"
            else
                ignoreDropdown.Visible = false
                igLabel.Text = L("aimbot_ignore") .. " [▼]"
            end
        end
    end)
end

-- NEW COMBAT
AddButton(tabCombat, L("rapid_fire") .. ": " .. L("off"), function(b,c) Settings.Combat.RapidFire = not Settings.Combat.RapidFire; b.Text = L("rapid_fire") .. ": " .. (Settings.Combat.RapidFire and L("on") or L("off")); c(Settings.Combat.RapidFire) end)
AddSlider(tabCombat, L("rapid_fire_delay"), 1, 50, 3, function(v) Settings.Combat.RapidFireDelay = v / 100 end)
AddButton(tabCombat, L("aimbot_jitter") .. ": " .. L("off"), function(b,c) Settings.Aimbot.Jitter = not Settings.Aimbot.Jitter; b.Text = L("aimbot_jitter") .. ": " .. (Settings.Aimbot.Jitter and L("on") or L("off")); c(Settings.Aimbot.Jitter) end)
AddSlider(tabCombat, L("jitter_amount"), 1, 20, 3, function(v) Settings.Aimbot.JitterAmount = v end)
AddButton(tabCombat, L("target_lock") .. ": " .. L("off"), function(b,c) Settings.Aimbot.TargetLock = not Settings.Aimbot.TargetLock; b.Text = L("target_lock") .. ": " .. (Settings.Aimbot.TargetLock and L("on") or L("off")); c(Settings.Aimbot.TargetLock) end)
AddButton(tabCombat, L("auto_switch") .. ": " .. L("off"), function(b,c) Settings.Aimbot.AutoSwitch = not Settings.Aimbot.AutoSwitch; b.Text = L("auto_switch") .. ": " .. (Settings.Aimbot.AutoSwitch and L("on") or L("off")); c(Settings.Aimbot.AutoSwitch) end)
AddButton(tabCombat, L("flick_bot") .. ": " .. L("off"), function(b,c) Settings.Aimbot.FlickBot = not Settings.Aimbot.FlickBot; b.Text = L("flick_bot") .. ": " .. (Settings.Aimbot.FlickBot and L("on") or L("off")); c(Settings.Aimbot.FlickBot) end)
AddButton(tabCombat, L("sticky_aim") .. ": " .. L("off"), function(b,c) Settings.Aimbot.StickyAim = not Settings.Aimbot.StickyAim; b.Text = L("sticky_aim") .. ": " .. (Settings.Aimbot.StickyAim and L("on") or L("off")); c(Settings.Aimbot.StickyAim) end)
AddButton(tabCombat, L("body_aim") .. ": " .. L("off"), function(b,c) Settings.Aimbot.BodyAimPriority = not Settings.Aimbot.BodyAimPriority; b.Text = L("body_aim") .. ": " .. (Settings.Aimbot.BodyAimPriority and L("on") or L("off")); c(Settings.Aimbot.BodyAimPriority) end)
AddButton(tabCombat, L("aim_assist") .. ": " .. L("off"), function(b,c) Settings.Aimbot.AimAssist = not Settings.Aimbot.AimAssist; b.Text = L("aim_assist") .. ": " .. (Settings.Aimbot.AimAssist and L("on") or L("off")); c(Settings.Aimbot.AimAssist) end)
AddSlider(tabCombat, L("aim_assist_str"), 1, 100, 30, function(v) Settings.Aimbot.AimAssistStr = v / 100 end)
AddButton(tabCombat, L("auto_shoot") .. ": " .. L("off"), function(b,c) Settings.Aimbot.AutoShoot = not Settings.Aimbot.AutoShoot; b.Text = L("auto_shoot") .. ": " .. (Settings.Aimbot.AutoShoot and L("on") or L("off")); c(Settings.Aimbot.AutoShoot) end)
AddSlider(tabCombat, L("max_angle"), 10, 180, 180, function(v) Settings.Aimbot.MaxAngle = v end)
AddButton(tabCombat, L("kill_aura") .. ": " .. L("off"), function(b,c) Settings.Combat.KillAura = not Settings.Combat.KillAura; b.Text = L("kill_aura") .. ": " .. (Settings.Combat.KillAura and L("on") or L("off")); c(Settings.Combat.KillAura) end)
AddSlider(tabCombat, L("kill_aura_range"), 5, 50, 15, function(v) Settings.Combat.KillAuraRange = v end)
AddButton(tabCombat, L("reach") .. ": " .. L("off"), function(b,c) Settings.Combat.Reach = not Settings.Combat.Reach; b.Text = L("reach") .. ": " .. (Settings.Combat.Reach and L("on") or L("off")); c(Settings.Combat.Reach) end)
AddSlider(tabCombat, L("reach_dist"), 5, 50, 20, function(v) Settings.Combat.ReachDist = v end)
AddButton(tabCombat, L("auto_block") .. ": " .. L("off"), function(b,c) Settings.Combat.AutoBlock = not Settings.Combat.AutoBlock; b.Text = L("auto_block") .. ": " .. (Settings.Combat.AutoBlock and L("on") or L("off")); c(Settings.Combat.AutoBlock) end)
AddButton(tabCombat, L("auto_parry") .. ": " .. L("off"), function(b,c) Settings.Combat.AutoParry = not Settings.Combat.AutoParry; b.Text = L("auto_parry") .. ": " .. (Settings.Combat.AutoParry and L("on") or L("off")); c(Settings.Combat.AutoParry) end)
AddButton(tabCombat, L("fast_attack") .. ": " .. L("off"), function(b,c) Settings.Combat.FastAttack = not Settings.Combat.FastAttack; b.Text = L("fast_attack") .. ": " .. (Settings.Combat.FastAttack and L("on") or L("off")); c(Settings.Combat.FastAttack) end)
AddButton(tabCombat, L("click_tp_attack") .. ": " .. L("off"), function(b,c) Settings.Combat.ClickTPAttack = not Settings.Combat.ClickTPAttack; b.Text = L("click_tp_attack") .. ": " .. (Settings.Combat.ClickTPAttack and L("on") or L("off")); c(Settings.Combat.ClickTPAttack) end)
AddButton(tabCombat, L("target_strafe") .. ": " .. L("off"), function(b,c) Settings.Combat.TargetStrafe = not Settings.Combat.TargetStrafe; b.Text = L("target_strafe") .. ": " .. (Settings.Combat.TargetStrafe and L("on") or L("off")); c(Settings.Combat.TargetStrafe) end)
AddSlider(tabCombat, L("strafe_radius"), 3, 20, 8, function(v) Settings.Combat.StrafeRadius = v end)
AddSlider(tabCombat, L("strafe_speed"), 1, 10, 3, function(v) Settings.Combat.StrafeSpeed = v end)
AddButton(tabCombat, L("auto_backstab") .. ": " .. L("off"), function(b,c) Settings.Combat.AutoBackstab = not Settings.Combat.AutoBackstab; b.Text = L("auto_backstab") .. ": " .. (Settings.Combat.AutoBackstab and L("on") or L("off")); c(Settings.Combat.AutoBackstab) end)
AddButton(tabCombat, L("combo_mode") .. ": " .. L("off"), function(b,c) Settings.Combat.ComboMode = not Settings.Combat.ComboMode; b.Text = L("combo_mode") .. ": " .. (Settings.Combat.ComboMode and L("on") or L("off")); c(Settings.Combat.ComboMode) end)

-- EXTRA COMBAT
AddButton(tabCombat, L("auto_clicker") .. ": " .. L("off"), function(b,c) Settings.Combat.AutoClicker = not Settings.Combat.AutoClicker; b.Text = L("auto_clicker") .. ": " .. (Settings.Combat.AutoClicker and L("on") or L("off")); c(Settings.Combat.AutoClicker) end)
AddButton(tabCombat, L("hit_chams") .. ": " .. L("off"), function(b,c) Settings.Combat.HitChams = not Settings.Combat.HitChams; b.Text = L("hit_chams") .. ": " .. (Settings.Combat.HitChams and L("on") or L("off")); c(Settings.Combat.HitChams) end)
AddButton(tabCombat, L("hit_sound") .. ": " .. L("off"), function(b,c) Settings.Combat.HitSound = not Settings.Combat.HitSound; b.Text = L("hit_sound") .. ": " .. (Settings.Combat.HitSound and L("on") or L("off")); c(Settings.Combat.HitSound) end)
AddButton(tabCombat, L("aimbot_priority"), function(b,c) local p = {1, 2}; local str = {"Distance", "Health"}; local cIdx = table.find(p, Settings.Combat.AimbotPriority) or 1; local nIdx = cIdx >= #p and 1 or cIdx + 1; Settings.Combat.AimbotPriority = p[nIdx]; b.Text = L("aimbot_priority") .. ": " .. str[nIdx]; c(true) end)

AddButton(tabMovement, L("noclip") .. ": " .. L("off"), function(b,c) Settings.Movement.Noclip = not Settings.Movement.Noclip; b.Text = L("noclip") .. ": " .. (Settings.Movement.Noclip and L("on") or L("off")); c(Settings.Movement.Noclip) end)
AddButton(tabMovement, L("fly") .. ": " .. L("off"), function(b,c) Settings.Movement.Fly = not Settings.Movement.Fly; b.Text = L("fly") .. ": " .. (Settings.Movement.Fly and L("on") or L("off")); c(Settings.Movement.Fly) end)

do
    local function updateFlyUI() end

    local row = Instance.new("Frame", tabMovement)
    row.Size = UDim2.new(1, -10, 0, 34); row.BackgroundTransparency = 1

    local minusBtn = Instance.new("TextButton", row)
    minusBtn.Size = UDim2.new(0, 36, 1, 0); minusBtn.Position = UDim2.new(0, 0, 0, 0)
    minusBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40); minusBtn.BackgroundTransparency = 0.7
    minusBtn.TextColor3 = Color3.fromRGB(220, 220, 235); minusBtn.Font = Enum.Font.GothamBold; minusBtn.TextSize = 18; minusBtn.Text = "-"
    Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)
    local st1 = Instance.new("UIStroke", minusBtn); st1.Color = Color3.fromRGB(200,200,220); st1.Transparency = 0.88; st1.Thickness = 1
    minusBtn.MouseEnter:Connect(function() TweenService:Create(minusBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
    minusBtn.MouseLeave:Connect(function() TweenService:Create(minusBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play() end)

    local speedInput = Instance.new("TextBox", row)
    speedInput.Size = UDim2.new(1, -190, 1, 0); speedInput.Position = UDim2.new(0, 40, 0, 0)
    speedInput.BackgroundColor3 = Color3.fromRGB(25, 25, 35); speedInput.BackgroundTransparency = 0.4
    speedInput.TextColor3 = Color3.fromRGB(210, 210, 225); speedInput.PlaceholderText = L("fly_speed")
    speedInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    speedInput.Font = Enum.Font.GothamSemibold; speedInput.TextSize = 12
    speedInput.Text = L("fly_speed") .. ": " .. Settings.Movement.Speed
    speedInput.ClearTextOnFocus = true
    Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 6)
    local stInput = Instance.new("UIStroke", speedInput); stInput.Color = Color3.fromRGB(200,200,220); stInput.Transparency = 0.88; stInput.Thickness = 1

    function updateFlyUI()
        speedInput.Text = L("fly_speed") .. ": " .. Settings.Movement.Speed
    end

    speedInput.FocusLost:Connect(function(enterPressed)
        local num = tonumber(speedInput.Text)
        if num and num >= 1 then
            Settings.Movement.Speed = math.floor(num)
        end
        updateFlyUI()
    end)

    local plusBtn = Instance.new("TextButton", row)
    plusBtn.Size = UDim2.new(0, 36, 1, 0); plusBtn.Position = UDim2.new(1, -145, 0, 0)
    plusBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40); plusBtn.BackgroundTransparency = 0.7
    plusBtn.TextColor3 = Color3.fromRGB(220, 220, 235); plusBtn.Font = Enum.Font.GothamBold; plusBtn.TextSize = 18; plusBtn.Text = "+"
    Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)
    local st2 = Instance.new("UIStroke", plusBtn); st2.Color = Color3.fromRGB(200,200,220); st2.Transparency = 0.88; st2.Thickness = 1
    plusBtn.MouseEnter:Connect(function() TweenService:Create(plusBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
    plusBtn.MouseLeave:Connect(function() TweenService:Create(plusBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play() end)

    local resetBtn = Instance.new("TextButton", row)
    resetBtn.Size = UDim2.new(0, 60, 1, 0); resetBtn.Position = UDim2.new(1, -105, 0, 0)
    resetBtn.BackgroundColor3 = Color3.fromRGB(130, 70, 220); resetBtn.BackgroundTransparency = 0.5
    resetBtn.TextColor3 = Color3.fromRGB(220, 220, 235); resetBtn.Font = Enum.Font.GothamSemibold; resetBtn.TextSize = 11; resetBtn.Text = L("fly_reset")
    Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)
    local st3 = Instance.new("UIStroke", resetBtn); st3.Color = Color3.fromRGB(160, 120, 255); st3.Transparency = 0.6; st3.Thickness = 1
    resetBtn.MouseEnter:Connect(function() TweenService:Create(resetBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play() end)
    resetBtn.MouseLeave:Connect(function() TweenService:Create(resetBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end)

    minusBtn.MouseButton1Click:Connect(function()
        Settings.Movement.Speed = math.max(1, Settings.Movement.Speed - 10)
        updateFlyUI()
    end)
    plusBtn.MouseButton1Click:Connect(function()
        Settings.Movement.Speed = Settings.Movement.Speed + 10
        updateFlyUI()
    end)
    resetBtn.MouseButton1Click:Connect(function()
        Settings.Movement.Speed = 10
        updateFlyUI()
    end)
end
AddButton(tabMovement, L("inf_jump") .. ": " .. L("off"), function(b,c) Settings.Movement.InfJump = not Settings.Movement.InfJump; b.Text = L("inf_jump") .. ": " .. (Settings.Movement.InfJump and L("on") or L("off")); c(Settings.Movement.InfJump) end)
AddButton(tabMovement, L("bhop") .. ": " .. L("off"), function(b,c) Settings.Movement.BHop = not Settings.Movement.BHop; b.Text = L("bhop") .. ": " .. (Settings.Movement.BHop and L("on") or L("off")); c(Settings.Movement.BHop) end)
AddButton(tabMovement, L("jumppower_hack") .. ": " .. L("off"), function(b,c) Settings.Movement.JumpPowerOn = not Settings.Movement.JumpPowerOn; b.Text = L("jumppower_hack") .. ": " .. (Settings.Movement.JumpPowerOn and L("on") or L("off")); c(Settings.Movement.JumpPowerOn) end)
AddSlider(tabMovement, L("jumppower"), 50, 500, 50, function(v) Settings.Movement.JumpPowerVal = v end)
AddButton(tabMovement, L("cframe_speed") .. ": " .. L("off"), function(b,c) Settings.Movement.CFrameSpeed = not Settings.Movement.CFrameSpeed; b.Text = L("cframe_speed") .. ": " .. (Settings.Movement.CFrameSpeed and L("on") or L("off")); c(Settings.Movement.CFrameSpeed) end)
do
    local function updateCFUI() end

    local cfRow = Instance.new("Frame", tabMovement)
    cfRow.Size = UDim2.new(1, -10, 0, 34); cfRow.BackgroundTransparency = 1

    local cfMinus = Instance.new("TextButton", cfRow)
    cfMinus.Size = UDim2.new(0, 36, 1, 0); cfMinus.Position = UDim2.new(0, 0, 0, 0)
    cfMinus.BackgroundColor3 = Color3.fromRGB(30, 30, 40); cfMinus.BackgroundTransparency = 0.7
    cfMinus.TextColor3 = Color3.fromRGB(220, 220, 235); cfMinus.Font = Enum.Font.GothamBold; cfMinus.TextSize = 18; cfMinus.Text = "-"
    Instance.new("UICorner", cfMinus).CornerRadius = UDim.new(0, 6)
    local cfSt1 = Instance.new("UIStroke", cfMinus); cfSt1.Color = Color3.fromRGB(200,200,220); cfSt1.Transparency = 0.88; cfSt1.Thickness = 1
    cfMinus.MouseEnter:Connect(function() TweenService:Create(cfMinus, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
    cfMinus.MouseLeave:Connect(function() TweenService:Create(cfMinus, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play() end)

    local cfInput = Instance.new("TextBox", cfRow)
    cfInput.Size = UDim2.new(1, -190, 1, 0); cfInput.Position = UDim2.new(0, 40, 0, 0)
    cfInput.BackgroundColor3 = Color3.fromRGB(25, 25, 35); cfInput.BackgroundTransparency = 0.4
    cfInput.TextColor3 = Color3.fromRGB(210, 210, 225); cfInput.PlaceholderText = L("cframe_power")
    cfInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    cfInput.Font = Enum.Font.GothamSemibold; cfInput.TextSize = 12
    cfInput.Text = L("cframe_power") .. ": " .. Settings.Movement.CFrameSpeedVal
    cfInput.ClearTextOnFocus = true
    Instance.new("UICorner", cfInput).CornerRadius = UDim.new(0, 6)
    local cfStInput = Instance.new("UIStroke", cfInput); cfStInput.Color = Color3.fromRGB(200,200,220); cfStInput.Transparency = 0.88; cfStInput.Thickness = 1

    function updateCFUI()
        cfInput.Text = L("cframe_power") .. ": " .. Settings.Movement.CFrameSpeedVal
    end

    cfInput.FocusLost:Connect(function(enterPressed)
        local num = tonumber(cfInput.Text)
        if num and num >= 1 then
            Settings.Movement.CFrameSpeedVal = math.floor(num)
        end
        updateCFUI()
    end)

    local cfPlus = Instance.new("TextButton", cfRow)
    cfPlus.Size = UDim2.new(0, 36, 1, 0); cfPlus.Position = UDim2.new(1, -145, 0, 0)
    cfPlus.BackgroundColor3 = Color3.fromRGB(30, 30, 40); cfPlus.BackgroundTransparency = 0.7
    cfPlus.TextColor3 = Color3.fromRGB(220, 220, 235); cfPlus.Font = Enum.Font.GothamBold; cfPlus.TextSize = 18; cfPlus.Text = "+"
    Instance.new("UICorner", cfPlus).CornerRadius = UDim.new(0, 6)
    local cfSt2 = Instance.new("UIStroke", cfPlus); cfSt2.Color = Color3.fromRGB(200,200,220); cfSt2.Transparency = 0.88; cfSt2.Thickness = 1
    cfPlus.MouseEnter:Connect(function() TweenService:Create(cfPlus, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
    cfPlus.MouseLeave:Connect(function() TweenService:Create(cfPlus, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play() end)

    local cfReset = Instance.new("TextButton", cfRow)
    cfReset.Size = UDim2.new(0, 60, 1, 0); cfReset.Position = UDim2.new(1, -105, 0, 0)
    cfReset.BackgroundColor3 = Color3.fromRGB(130, 70, 220); cfReset.BackgroundTransparency = 0.5
    cfReset.TextColor3 = Color3.fromRGB(220, 220, 235); cfReset.Font = Enum.Font.GothamSemibold; cfReset.TextSize = 11; cfReset.Text = "Reset 2"
    Instance.new("UICorner", cfReset).CornerRadius = UDim.new(0, 6)
    local cfSt3 = Instance.new("UIStroke", cfReset); cfSt3.Color = Color3.fromRGB(160, 120, 255); cfSt3.Transparency = 0.6; cfSt3.Thickness = 1
    cfReset.MouseEnter:Connect(function() TweenService:Create(cfReset, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play() end)
    cfReset.MouseLeave:Connect(function() TweenService:Create(cfReset, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end)

    cfMinus.MouseButton1Click:Connect(function()
        Settings.Movement.CFrameSpeedVal = math.max(1, Settings.Movement.CFrameSpeedVal - 1)
        updateCFUI()
    end)
    cfPlus.MouseButton1Click:Connect(function()
        Settings.Movement.CFrameSpeedVal = Settings.Movement.CFrameSpeedVal + 1
        updateCFUI()
    end)
    cfReset.MouseButton1Click:Connect(function()
        Settings.Movement.CFrameSpeedVal = 2
        updateCFUI()
    end)
end
AddButton(tabMovement, L("anti_void") .. ": " .. L("off"), function(b,c) Settings.Movement.AntiVoid = not Settings.Movement.AntiVoid; b.Text = L("anti_void") .. ": " .. (Settings.Movement.AntiVoid and L("on") or L("off")); c(Settings.Movement.AntiVoid) end)
AddButton(tabMovement, L("spider") .. ": " .. L("off"), function(b,c) Settings.Movement.Spider = not Settings.Movement.Spider; b.Text = L("spider") .. ": " .. (Settings.Movement.Spider and L("on") or L("off")); c(Settings.Movement.Spider) end)
AddButton(tabMovement, L("anti_kb") .. ": " .. L("off"), function(b,c) Settings.Movement.AntiKnockback = not Settings.Movement.AntiKnockback; b.Text = L("anti_kb") .. ": " .. (Settings.Movement.AntiKnockback and L("on") or L("off")); c(Settings.Movement.AntiKnockback) end)
AddButton(tabMovement, L("tp_mouse") .. ": " .. L("off"), function(b,c) Settings.Movement.TPtoMouse = not Settings.Movement.TPtoMouse; b.Text = L("tp_mouse") .. ": " .. (Settings.Movement.TPtoMouse and L("on") or L("off")); c(Settings.Movement.TPtoMouse) end)
AddButton(tabMovement, L("walk_speed") .. ": " .. L("off"), function(b,c) Settings.Movement.WalkSpeedOn = not Settings.Movement.WalkSpeedOn; b.Text = L("walk_speed") .. ": " .. (Settings.Movement.WalkSpeedOn and L("on") or L("off")); c(Settings.Movement.WalkSpeedOn) end)
do
    local function updateWSUI() end
    local wsRow = Instance.new("Frame", tabMovement)
    wsRow.Size = UDim2.new(1, -10, 0, 34); wsRow.BackgroundTransparency = 1
    local wsMinus = Instance.new("TextButton", wsRow)
    wsMinus.Size = UDim2.new(0, 36, 1, 0); wsMinus.Position = UDim2.new(0, 0, 0, 0)
    wsMinus.BackgroundColor3 = Color3.fromRGB(30, 30, 40); wsMinus.BackgroundTransparency = 0.7
    wsMinus.TextColor3 = Color3.fromRGB(220, 220, 235); wsMinus.Font = Enum.Font.GothamBold; wsMinus.TextSize = 18; wsMinus.Text = "-"
    Instance.new("UICorner", wsMinus).CornerRadius = UDim.new(0, 6)
    local wsSt1 = Instance.new("UIStroke", wsMinus); wsSt1.Color = Color3.fromRGB(200,200,220); wsSt1.Transparency = 0.88; wsSt1.Thickness = 1
    wsMinus.MouseEnter:Connect(function() TweenService:Create(wsMinus, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
    wsMinus.MouseLeave:Connect(function() TweenService:Create(wsMinus, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play() end)
    local wsInput = Instance.new("TextBox", wsRow)
    wsInput.Size = UDim2.new(1, -190, 1, 0); wsInput.Position = UDim2.new(0, 40, 0, 0)
    wsInput.BackgroundColor3 = Color3.fromRGB(25, 25, 35); wsInput.BackgroundTransparency = 0.4
    wsInput.TextColor3 = Color3.fromRGB(210, 210, 225); wsInput.PlaceholderText = L("walk_speed_val")
    wsInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    wsInput.Font = Enum.Font.GothamSemibold; wsInput.TextSize = 12
    wsInput.Text = L("walk_speed_val") .. ": " .. Settings.Movement.WalkSpeedVal
    wsInput.ClearTextOnFocus = true
    Instance.new("UICorner", wsInput).CornerRadius = UDim.new(0, 6)
    local wsStI = Instance.new("UIStroke", wsInput); wsStI.Color = Color3.fromRGB(200,200,220); wsStI.Transparency = 0.88; wsStI.Thickness = 1
    function updateWSUI() wsInput.Text = L("walk_speed_val") .. ": " .. Settings.Movement.WalkSpeedVal end
    wsInput.FocusLost:Connect(function() local n = tonumber(wsInput.Text); if n and n >= 1 then Settings.Movement.WalkSpeedVal = math.floor(n) end; updateWSUI() end)
    local wsPlus = Instance.new("TextButton", wsRow)
    wsPlus.Size = UDim2.new(0, 36, 1, 0); wsPlus.Position = UDim2.new(1, -145, 0, 0)
    wsPlus.BackgroundColor3 = Color3.fromRGB(30, 30, 40); wsPlus.BackgroundTransparency = 0.7
    wsPlus.TextColor3 = Color3.fromRGB(220, 220, 235); wsPlus.Font = Enum.Font.GothamBold; wsPlus.TextSize = 18; wsPlus.Text = "+"
    Instance.new("UICorner", wsPlus).CornerRadius = UDim.new(0, 6)
    local wsSt2 = Instance.new("UIStroke", wsPlus); wsSt2.Color = Color3.fromRGB(200,200,220); wsSt2.Transparency = 0.88; wsSt2.Thickness = 1
    wsPlus.MouseEnter:Connect(function() TweenService:Create(wsPlus, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
    wsPlus.MouseLeave:Connect(function() TweenService:Create(wsPlus, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play() end)
    local wsReset = Instance.new("TextButton", wsRow)
    wsReset.Size = UDim2.new(0, 60, 1, 0); wsReset.Position = UDim2.new(1, -105, 0, 0)
    wsReset.BackgroundColor3 = Color3.fromRGB(130, 70, 220); wsReset.BackgroundTransparency = 0.5
    wsReset.TextColor3 = Color3.fromRGB(220, 220, 235); wsReset.Font = Enum.Font.GothamSemibold; wsReset.TextSize = 11; wsReset.Text = "Reset 16"
    Instance.new("UICorner", wsReset).CornerRadius = UDim.new(0, 6)
    local wsSt3 = Instance.new("UIStroke", wsReset); wsSt3.Color = Color3.fromRGB(160, 120, 255); wsSt3.Transparency = 0.6; wsSt3.Thickness = 1
    wsReset.MouseEnter:Connect(function() TweenService:Create(wsReset, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play() end)
    wsReset.MouseLeave:Connect(function() TweenService:Create(wsReset, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end)
    wsMinus.MouseButton1Click:Connect(function() Settings.Movement.WalkSpeedVal = math.max(1, Settings.Movement.WalkSpeedVal - 10); updateWSUI() end)
    wsPlus.MouseButton1Click:Connect(function() Settings.Movement.WalkSpeedVal = Settings.Movement.WalkSpeedVal + 10; updateWSUI() end)
    wsReset.MouseButton1Click:Connect(function() Settings.Movement.WalkSpeedVal = 16; updateWSUI() end)
end
AddButton(tabMovement, L("lag_speed") .. ": " .. L("off"), function(b,c) Settings.Movement.LagSpeed = not Settings.Movement.LagSpeed; b.Text = L("lag_speed") .. ": " .. (Settings.Movement.LagSpeed and L("on") or L("off")); c(Settings.Movement.LagSpeed) end)
do
    local function updateLSUI() end
    local lsRow = Instance.new("Frame", tabMovement)
    lsRow.Size = UDim2.new(1, -10, 0, 34); lsRow.BackgroundTransparency = 1
    local lsMinus = Instance.new("TextButton", lsRow)
    lsMinus.Size = UDim2.new(0, 36, 1, 0); lsMinus.Position = UDim2.new(0, 0, 0, 0)
    lsMinus.BackgroundColor3 = Color3.fromRGB(30, 30, 40); lsMinus.BackgroundTransparency = 0.7
    lsMinus.TextColor3 = Color3.fromRGB(220, 220, 235); lsMinus.Font = Enum.Font.GothamBold; lsMinus.TextSize = 18; lsMinus.Text = "-"
    Instance.new("UICorner", lsMinus).CornerRadius = UDim.new(0, 6)
    local lsSt1 = Instance.new("UIStroke", lsMinus); lsSt1.Color = Color3.fromRGB(200,200,220); lsSt1.Transparency = 0.88; lsSt1.Thickness = 1
    lsMinus.MouseEnter:Connect(function() TweenService:Create(lsMinus, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
    lsMinus.MouseLeave:Connect(function() TweenService:Create(lsMinus, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play() end)
    local lsInput = Instance.new("TextBox", lsRow)
    lsInput.Size = UDim2.new(1, -190, 1, 0); lsInput.Position = UDim2.new(0, 40, 0, 0)
    lsInput.BackgroundColor3 = Color3.fromRGB(25, 25, 35); lsInput.BackgroundTransparency = 0.4
    lsInput.TextColor3 = Color3.fromRGB(210, 210, 225); lsInput.PlaceholderText = L("lag_speed_power")
    lsInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    lsInput.Font = Enum.Font.GothamSemibold; lsInput.TextSize = 12
    lsInput.Text = L("lag_speed_power") .. ": " .. Settings.Movement.LagSpeedVal
    lsInput.ClearTextOnFocus = true
    Instance.new("UICorner", lsInput).CornerRadius = UDim.new(0, 6)
    local lsStI = Instance.new("UIStroke", lsInput); lsStI.Color = Color3.fromRGB(200,200,220); lsStI.Transparency = 0.88; lsStI.Thickness = 1
    function updateLSUI() lsInput.Text = L("lag_speed_power") .. ": " .. Settings.Movement.LagSpeedVal end
    lsInput.FocusLost:Connect(function() local n = tonumber(lsInput.Text); if n and n >= 1 then Settings.Movement.LagSpeedVal = math.floor(n) end; updateLSUI() end)
    local lsPlus = Instance.new("TextButton", lsRow)
    lsPlus.Size = UDim2.new(0, 36, 1, 0); lsPlus.Position = UDim2.new(1, -145, 0, 0)
    lsPlus.BackgroundColor3 = Color3.fromRGB(30, 30, 40); lsPlus.BackgroundTransparency = 0.7
    lsPlus.TextColor3 = Color3.fromRGB(220, 220, 235); lsPlus.Font = Enum.Font.GothamBold; lsPlus.TextSize = 18; lsPlus.Text = "+"
    Instance.new("UICorner", lsPlus).CornerRadius = UDim.new(0, 6)
    local lsSt2 = Instance.new("UIStroke", lsPlus); lsSt2.Color = Color3.fromRGB(200,200,220); lsSt2.Transparency = 0.88; lsSt2.Thickness = 1
    lsPlus.MouseEnter:Connect(function() TweenService:Create(lsPlus, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
    lsPlus.MouseLeave:Connect(function() TweenService:Create(lsPlus, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play() end)
    local lsReset = Instance.new("TextButton", lsRow)
    lsReset.Size = UDim2.new(0, 60, 1, 0); lsReset.Position = UDim2.new(1, -105, 0, 0)
    lsReset.BackgroundColor3 = Color3.fromRGB(130, 70, 220); lsReset.BackgroundTransparency = 0.5
    lsReset.TextColor3 = Color3.fromRGB(220, 220, 235); lsReset.Font = Enum.Font.GothamSemibold; lsReset.TextSize = 11; lsReset.Text = "Reset 5"
    Instance.new("UICorner", lsReset).CornerRadius = UDim.new(0, 6)
    local lsSt3 = Instance.new("UIStroke", lsReset); lsSt3.Color = Color3.fromRGB(160, 120, 255); lsSt3.Transparency = 0.6; lsSt3.Thickness = 1
    lsReset.MouseEnter:Connect(function() TweenService:Create(lsReset, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play() end)
    lsReset.MouseLeave:Connect(function() TweenService:Create(lsReset, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end)
    lsMinus.MouseButton1Click:Connect(function() Settings.Movement.LagSpeedVal = math.max(1, Settings.Movement.LagSpeedVal - 1); updateLSUI() end)
    lsPlus.MouseButton1Click:Connect(function() Settings.Movement.LagSpeedVal = Settings.Movement.LagSpeedVal + 1; updateLSUI() end)
    lsReset.MouseButton1Click:Connect(function() Settings.Movement.LagSpeedVal = 5; updateLSUI() end)
end
-- NEW MOVEMENT
AddButton(tabMovement, L("long_jump") .. ": " .. L("off"), function(b,c) Settings.Movement.LongJump = not Settings.Movement.LongJump; b.Text = L("long_jump") .. ": " .. (Settings.Movement.LongJump and L("on") or L("off")); c(Settings.Movement.LongJump) end)
AddSlider(tabMovement, L("long_jump_power"), 20, 200, 80, function(v) Settings.Movement.LongJumpPower = v end)
AddButton(tabMovement, L("high_jump") .. ": " .. L("off"), function(b,c) Settings.Movement.HighJump = not Settings.Movement.HighJump; b.Text = L("high_jump") .. ": " .. (Settings.Movement.HighJump and L("on") or L("off")); c(Settings.Movement.HighJump) end)
AddSlider(tabMovement, L("high_jump_power"), 50, 300, 100, function(v) Settings.Movement.HighJumpPower = v end)
AddButton(tabMovement, L("glide") .. ": " .. L("off"), function(b,c) Settings.Movement.Glide = not Settings.Movement.Glide; b.Text = L("glide") .. ": " .. (Settings.Movement.Glide and L("on") or L("off")); c(Settings.Movement.Glide) end)
AddSlider(tabMovement, L("glide_speed"), 5, 50, 20, function(v) Settings.Movement.GlideSpeed = v end)
AddButton(tabMovement, L("freeze_pos") .. ": " .. L("off"), function(b,c) Settings.Movement.FreezePos = not Settings.Movement.FreezePos; b.Text = L("freeze_pos") .. ": " .. (Settings.Movement.FreezePos and L("on") or L("off")); c(Settings.Movement.FreezePos) end)
AddButton(tabMovement, L("dash") .. ": " .. L("off"), function(b,c) Settings.Movement.Dash = not Settings.Movement.Dash; b.Text = L("dash") .. ": " .. (Settings.Movement.Dash and L("on") or L("off")); c(Settings.Movement.Dash) end)
AddSlider(tabMovement, L("dash_power"), 10, 150, 60, function(v) Settings.Movement.DashPower = v end)
AddButton(tabMovement, L("tp_forward"), function(b,c) local ch = LocalPlayer.Character; local h = ch and ch:FindFirstChild("HumanoidRootPart"); if h then h.CFrame = h.CFrame + h.CFrame.LookVector * Settings.Movement.TPForwardDist end; c(true) end)
AddSlider(tabMovement, L("tp_forward_dist"), 5, 50, 15, function(v) Settings.Movement.TPForwardDist = v end)
AddButton(tabMovement, L("auto_walk") .. ": " .. L("off"), function(b,c) Settings.Movement.AutoWalk = not Settings.Movement.AutoWalk; b.Text = L("auto_walk") .. ": " .. (Settings.Movement.AutoWalk and L("on") or L("off")); c(Settings.Movement.AutoWalk) end)
AddButton(tabMovement, L("follow_player") .. ": " .. L("off"), function(b,c) Settings.Movement.FollowPlayer = not Settings.Movement.FollowPlayer; b.Text = L("follow_player") .. ": " .. (Settings.Movement.FollowPlayer and L("on") or L("off")); c(Settings.Movement.FollowPlayer) end)
AddButton(tabMovement, L("orbit_player") .. ": " .. L("off"), function(b,c) Settings.Movement.OrbitPlayer = not Settings.Movement.OrbitPlayer; b.Text = L("orbit_player") .. ": " .. (Settings.Movement.OrbitPlayer and L("on") or L("off")); c(Settings.Movement.OrbitPlayer) end)
AddSlider(tabMovement, L("orbit_radius"), 3, 30, 10, function(v) Settings.Movement.OrbitRadius = v end)
AddSlider(tabMovement, L("orbit_speed"), 1, 10, 2, function(v) Settings.Movement.OrbitSpeed = v end)
AddButton(tabMovement, L("inv_platform") .. ": " .. L("off"), function(b,c) Settings.Movement.InvPlatform = not Settings.Movement.InvPlatform; b.Text = L("inv_platform") .. ": " .. (Settings.Movement.InvPlatform and L("on") or L("off")); c(Settings.Movement.InvPlatform) end)
AddButton(tabMovement, L("jesus_walk") .. ": " .. L("off"), function(b,c) Settings.Movement.JesusWalk = not Settings.Movement.JesusWalk; b.Text = L("jesus_walk") .. ": " .. (Settings.Movement.JesusWalk and L("on") or L("off")); c(Settings.Movement.JesusWalk) end)
AddButton(tabMovement, L("phase") .. ": " .. L("off"), function(b,c) Settings.Movement.Phase = not Settings.Movement.Phase; b.Text = L("phase") .. ": " .. (Settings.Movement.Phase and L("on") or L("off")); c(Settings.Movement.Phase) end)
AddButton(tabMovement, L("moon_jump") .. ": " .. L("off"), function(b,c) Settings.Movement.MoonJump = not Settings.Movement.MoonJump; b.Text = L("moon_jump") .. ": " .. (Settings.Movement.MoonJump and L("on") or L("off")); c(Settings.Movement.MoonJump) end)
AddButton(tabMovement, L("slide_on") .. ": " .. L("off"), function(b,c) Settings.Movement.SlideOn = not Settings.Movement.SlideOn; b.Text = L("slide_on") .. ": " .. (Settings.Movement.SlideOn and L("on") or L("off")); c(Settings.Movement.SlideOn) end)
AddButton(tabMovement, L("step_on") .. ": " .. L("off"), function(b,c) Settings.Movement.StepOn = not Settings.Movement.StepOn; b.Text = L("step_on") .. ": " .. (Settings.Movement.StepOn and L("on") or L("off")); c(Settings.Movement.StepOn) end)
AddButton(tabMovement, L("auto_sprint") .. ": " .. L("off"), function(b,c) Settings.Movement.AutoSprint = not Settings.Movement.AutoSprint; b.Text = L("auto_sprint") .. ": " .. (Settings.Movement.AutoSprint and L("on") or L("off")); c(Settings.Movement.AutoSprint) end)
AddButton(tabMovement, L("speed_pulse") .. ": " .. L("off"), function(b,c) Settings.Movement.SpeedPulse = not Settings.Movement.SpeedPulse; b.Text = L("speed_pulse") .. ": " .. (Settings.Movement.SpeedPulse and L("on") or L("off")); c(Settings.Movement.SpeedPulse) end)
AddSlider(tabMovement, L("speed_pulse_min"), 1, 50, 16, function(v) Settings.Movement.SpeedPulseMin = v end)
AddSlider(tabMovement, L("speed_pulse_max"), 10, 100, 50, function(v) Settings.Movement.SpeedPulseMax = v end)
AddButton(tabMovement, L("tp_up"), function(b,c) local ch = LocalPlayer.Character; local h = ch and ch:FindFirstChild("HumanoidRootPart"); if h then h.CFrame = h.CFrame + Vector3.new(0,50,0) end; c(true) end)
AddButton(tabMovement, L("tp_down"), function(b,c) local ch = LocalPlayer.Character; local h = ch and ch:FindFirstChild("HumanoidRootPart"); if h then h.CFrame = h.CFrame - Vector3.new(0,50,0) end; c(true) end)
AddButton(tabMovement, L("safe_walk") .. ": " .. L("off"), function(b,c) Settings.Movement.SafeWalk = not Settings.Movement.SafeWalk; b.Text = L("safe_walk") .. ": " .. (Settings.Movement.SafeWalk and L("on") or L("off")); c(Settings.Movement.SafeWalk) end)
AddButton(tabMovement, L("edge_jump") .. ": " .. L("off"), function(b,c) Settings.Movement.EdgeJump = not Settings.Movement.EdgeJump; b.Text = L("edge_jump") .. ": " .. (Settings.Movement.EdgeJump and L("on") or L("off")); c(Settings.Movement.EdgeJump) end)
AddButton(tabMovement, L("bunny_fly") .. ": " .. L("off"), function(b,c) Settings.Movement.BunnyFly = not Settings.Movement.BunnyFly; b.Text = L("bunny_fly") .. ": " .. (Settings.Movement.BunnyFly and L("on") or L("off")); c(Settings.Movement.BunnyFly) end)

-- EXTRA MOVEMENT
AddButton(tabMovement, L("fake_lag_v1") .. ": " .. L("off"), function(b,c) Settings.Movement.FakeLagV1 = not Settings.Movement.FakeLagV1; b.Text = L("fake_lag_v1") .. ": " .. (Settings.Movement.FakeLagV1 and L("on") or L("off")); c(Settings.Movement.FakeLagV1) end)
AddButton(tabMovement, L("tween_tp") .. ": " .. L("off"), function(b,c) Settings.Movement.TweenTP = not Settings.Movement.TweenTP; b.Text = L("tween_tp") .. ": " .. (Settings.Movement.TweenTP and L("on") or L("off")); c(Settings.Movement.TweenTP) end)
AddButton(tabMovement, L("step_back") .. ": " .. L("off"), function(b,c) Settings.Movement.StepBack = not Settings.Movement.StepBack; b.Text = L("step_back") .. ": " .. (Settings.Movement.StepBack and L("on") or L("off")); c(Settings.Movement.StepBack) end)

AddButton(tabWorld, L("fullbright") .. ": " .. L("off"), function(b,c) Settings.World.Fullbright = not Settings.World.Fullbright; b.Text = L("fullbright") .. ": " .. (Settings.World.Fullbright and L("on") or L("off")); c(Settings.World.Fullbright); if Settings.World.Fullbright then Lighting.Ambient = Color3.new(1,1,1); Lighting.Brightness = 2 else Lighting.Ambient = Color3.fromRGB(128,128,128); Lighting.Brightness = 1 end end)
AddSlider(tabWorld, L("fov_camera"), 70, 120, 70, function(v) Camera.FieldOfView = v end)
AddButton(tabWorld, L("low_gravity") .. ": " .. L("off"), function(b,c) Settings.World.LowGravity = not Settings.World.LowGravity; b.Text = L("low_gravity") .. ": " .. (Settings.World.LowGravity and L("on") or L("off")); c(Settings.World.LowGravity); if not Settings.World.LowGravity then Workspace.Gravity = 196.2 end end)
AddSlider(tabWorld, L("low_grav_val"), 0, 196, 50, function(v) Settings.World.GravityVal = v end)
AddButton(tabWorld, L("time_of_day_on") .. ": " .. L("off"), function(b,c) Settings.World.TimeOfDayOn = not Settings.World.TimeOfDayOn; b.Text = L("time_of_day_on") .. ": " .. (Settings.World.TimeOfDayOn and L("on") or L("off")); c(Settings.World.TimeOfDayOn) end)
AddSlider(tabWorld, L("time_of_day"), 0, 24, 14, function(v) Settings.World.TimeOfDay = v end)
-- NEW WORLD
AddButton(tabWorld, L("xray") .. ": " .. L("off"), function(b,c) Settings.World.XRay = not Settings.World.XRay; b.Text = L("xray") .. ": " .. (Settings.World.XRay and L("on") or L("off")); c(Settings.World.XRay)
    if Settings.World.XRay then for _,v in ipairs(Workspace:GetDescendants()) do if v:IsA("BasePart") and not Players:GetPlayerFromCharacter(v.Parent) and not Players:GetPlayerFromCharacter(v.Parent and v.Parent.Parent) then v.Transparency = math.max(v.Transparency, 0.7) end end end
end)
AddButton(tabWorld, L("wireframe") .. ": " .. L("off"), function(b,c) Settings.World.Wireframe = not Settings.World.Wireframe; b.Text = L("wireframe") .. ": " .. (Settings.World.Wireframe and L("on") or L("off")); c(Settings.World.Wireframe) end)
AddSlider(tabWorld, L("wireframe_trans"), 1, 10, 7, function(v) Settings.World.WireframeTrans = v / 10 end)
AddButton(tabWorld, L("remove_decals"), function(b,c) local r=0; for _,v in ipairs(Workspace:GetDescendants()) do if v:IsA("Decal") or v:IsA("Texture") then v:Destroy(); r=r+1 end end; SendNotify("Removed "..r.." decals"); c(true) end)
AddButton(tabWorld, L("remove_meshes"), function(b,c) local r=0; for _,v in ipairs(Workspace:GetDescendants()) do if v:IsA("SpecialMesh") then v:Destroy(); r=r+1 end end; SendNotify("Removed "..r.." meshes"); c(true) end)
AddButton(tabWorld, L("big_head") .. ": " .. L("off"), function(b,c) Settings.World.BigHead = not Settings.World.BigHead; b.Text = L("big_head") .. ": " .. (Settings.World.BigHead and L("on") or L("off")); c(Settings.World.BigHead) end)
AddSlider(tabWorld, L("big_head_size"), 2, 20, 5, function(v) Settings.World.BigHeadSize = v end)
AddButton(tabWorld, L("small_players") .. ": " .. L("off"), function(b,c) Settings.World.SmallPlayers = not Settings.World.SmallPlayers; b.Text = L("small_players") .. ": " .. (Settings.World.SmallPlayers and L("on") or L("off")); c(Settings.World.SmallPlayers) end)
AddButton(tabWorld, L("custom_ambient") .. ": " .. L("off"), function(b,c) Settings.World.CustomAmbient = not Settings.World.CustomAmbient; b.Text = L("custom_ambient") .. ": " .. (Settings.World.CustomAmbient and L("on") or L("off")); c(Settings.World.CustomAmbient) end)
AddButton(tabWorld, L("remove_water"), function(b,c) pcall(function() Workspace.Terrain:SetMaterialColor(Enum.Material.Water, Color3.new(0,0,0)) end); SendNotify("Water hidden"); c(true) end)
AddButton(tabWorld, L("auto_day_night") .. ": " .. L("off"), function(b,c) Settings.World.AutoDayNight = not Settings.World.AutoDayNight; b.Text = L("auto_day_night") .. ": " .. (Settings.World.AutoDayNight and L("on") or L("off")); c(Settings.World.AutoDayNight) end)
AddButton(tabWorld, L("world_freeze") .. ": " .. L("off"), function(b,c) Settings.World.WorldFreeze = not Settings.World.WorldFreeze; b.Text = L("world_freeze") .. ": " .. (Settings.World.WorldFreeze and L("on") or L("off")); c(Settings.World.WorldFreeze) end)
AddButton(tabWorld, L("no_cam_shake") .. ": " .. L("off"), function(b,c) Settings.World.NoCamShake = not Settings.World.NoCamShake; b.Text = L("no_cam_shake") .. ": " .. (Settings.World.NoCamShake and L("on") or L("off")); c(Settings.World.NoCamShake) end)
AddButton(tabWorld, L("no_hud") .. ": " .. L("off"), function(b,c) Settings.World.NoHUD = not Settings.World.NoHUD; b.Text = L("no_hud") .. ": " .. (Settings.World.NoHUD and L("on") or L("off")); c(Settings.World.NoHUD)
    if Settings.World.NoHUD then for _,g in ipairs(LocalPlayer.PlayerGui:GetChildren()) do if g:IsA("ScreenGui") and g ~= screenGui then g.Enabled = false end end
    else for _,g in ipairs(LocalPlayer.PlayerGui:GetChildren()) do if g:IsA("ScreenGui") then g.Enabled = true end end end
end)
AddButton(tabWorld, L("remove_particles") .. ": " .. L("off"), function(b,c) Settings.World.RemoveParticles = not Settings.World.RemoveParticles; b.Text = L("remove_particles") .. ": " .. (Settings.World.RemoveParticles and L("on") or L("off")); c(Settings.World.RemoveParticles) end)

-- EXTRA WORLD
AddButton(tabWorld, L("no_textures") .. ": " .. L("off"), function(b,c) Settings.World.NoTextures = not Settings.World.NoTextures; b.Text = L("no_textures") .. ": " .. (Settings.World.NoTextures and L("on") or L("off")); c(Settings.World.NoTextures) end)
AddButton(tabWorld, L("dark_mode") .. ": " .. L("off"), function(b,c) Settings.World.DarkMode = not Settings.World.DarkMode; b.Text = L("dark_mode") .. ": " .. (Settings.World.DarkMode and L("on") or L("off")); c(Settings.World.DarkMode) end)
AddButton(tabWorld, L("remove_trees") .. ": " .. L("off"), function(b,c) Settings.World.RemoveTrees = not Settings.World.RemoveTrees; b.Text = L("remove_trees") .. ": " .. (Settings.World.RemoveTrees and L("on") or L("off")); c(Settings.World.RemoveTrees) end)
AddButton(tabWorld, L("remove_doors") .. ": " .. L("off"), function(b,c) Settings.World.RemoveDoors = not Settings.World.RemoveDoors; b.Text = L("remove_doors") .. ": " .. (Settings.World.RemoveDoors and L("on") or L("off")); c(Settings.World.RemoveDoors) end)
AddButton(tabWorld, L("disable_killbricks") .. ": " .. L("off"), function(b,c) Settings.World.DisableKillbricks = not Settings.World.DisableKillbricks; b.Text = L("disable_killbricks") .. ": " .. (Settings.World.DisableKillbricks and L("on") or L("off")); c(Settings.World.DisableKillbricks) end)

AddButton(tabRage, L("open_target"), function(b,c)
    playerWindow.Visible = not playerWindow.Visible
    if playerWindow.Visible then RefreshPlayerList(searchBox.Text) end
    c(playerWindow.Visible)
end)
AddButton(tabRage, L("stop_spectate"), function(b,c) 
    Settings.TP.Spectating = false
    Settings.TP.SpectateTarget = nil
    spectateUIBtn.Text = L("spectate")
    spectateUIBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 30)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end; c(true)
end)
AddButton(tabRage, L("spinbot") .. ": " .. L("off"), function(b,c) Settings.Rage.Spinbot = not Settings.Rage.Spinbot; b.Text = L("spinbot") .. ": " .. (Settings.Rage.Spinbot and L("on") or L("off")); c(Settings.Rage.Spinbot) end)
AddButton(tabRage, L("anti_aim") .. ": " .. L("off"), function(b,c)
    Settings.Rage.AntiAim = not Settings.Rage.AntiAim
    b.Text = L("anti_aim") .. ": " .. (Settings.Rage.AntiAim and L("on") or L("off"))
    c(Settings.Rage.AntiAim)
    if Settings.Rage.AntiAim then SendNotify(L("notify_anti_aim")) end
end)

AddButton(tabRage, L("god_mode"), function(b,c)
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local cam = Workspace.CurrentCamera
        local hum = char:FindFirstChildOfClass("Humanoid")
        hum.Name = "1"
        local newHum = hum:Clone()
        newHum.Name = "Humanoid"
        newHum.Parent = char
        hum:Destroy()
        cam.CameraSubject = newHum

        local animate = char:FindFirstChild("Animate")
        if animate then
            local animateClone = animate:Clone()
            animate:Destroy()
            animateClone.Parent = char
        end
        c(true)
    end
end)

-- // PROTECTION TAB
AddButton(tabProtection, L("anti_kick") .. ": " .. L("off"), function(b,c) Settings.Protection.AntiKick = not Settings.Protection.AntiKick; b.Text = L("anti_kick") .. ": " .. (Settings.Protection.AntiKick and L("on") or L("off")); c(Settings.Protection.AntiKick)
    if Settings.Protection.AntiKick then SendNotify(L("notify_anti_kick")) end
end)
AddButton(tabProtection, L("anti_ss") .. ": " .. L("off"), function(b,c)
    Settings.Protection.AntiScreenshot = not Settings.Protection.AntiScreenshot
    b.Text = L("anti_ss") .. ": " .. (Settings.Protection.AntiScreenshot and L("on") or L("off"))
    c(Settings.Protection.AntiScreenshot)
    if Settings.Protection.AntiScreenshot then
        screenGui.DisplayOrder = -999999
        SendNotify(L("notify_anti_ss"))
    else
        screenGui.DisplayOrder = 999999
    end
end)
AddButton(tabProtection, L("anti_lag") .. ": " .. L("off"), function(b,c)
    Settings.Protection.AntiLag = not Settings.Protection.AntiLag
    b.Text = L("anti_lag") .. ": " .. (Settings.Protection.AntiLag and L("on") or L("off"))
    c(Settings.Protection.AntiLag)
    if Settings.Protection.AntiLag then
        local removed = 0
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v:Destroy(); removed = removed + 1
            end
        end
        SendNotify(string.format(L("notify_anti_lag"), removed))
    end
end)

-- Performance Guard
AddButton(tabProtection, L("perf_guard") .. ": " .. L("off"), function(b,c)
    Settings.PerfGuard.Enabled = not Settings.PerfGuard.Enabled
    b.Text = L("perf_guard") .. ": " .. (Settings.PerfGuard.Enabled and L("on") or L("off"))
    c(Settings.PerfGuard.Enabled)
    if Settings.PerfGuard.Enabled then SendNotify(L("notify_perf_on")) end
end)
AddSlider(tabProtection, L("perf_guard_fps"), 15, 60, 30, function(v) Settings.PerfGuard.MinFPS = v end)
-- NEW PROTECTION
AddButton(tabProtection, L("anti_fling") .. ": " .. L("off"), function(b,c) Settings.Protection.AntiFling = not Settings.Protection.AntiFling; b.Text = L("anti_fling") .. ": " .. (Settings.Protection.AntiFling and L("on") or L("off")); c(Settings.Protection.AntiFling) end)
AddButton(tabProtection, L("anti_tp") .. ": " .. L("off"), function(b,c) Settings.Protection.AntiTP = not Settings.Protection.AntiTP; b.Text = L("anti_tp") .. ": " .. (Settings.Protection.AntiTP and L("on") or L("off")); c(Settings.Protection.AntiTP) end)
AddButton(tabProtection, L("anti_slow") .. ": " .. L("off"), function(b,c) Settings.Protection.AntiSlow = not Settings.Protection.AntiSlow; b.Text = L("anti_slow") .. ": " .. (Settings.Protection.AntiSlow and L("on") or L("off")); c(Settings.Protection.AntiSlow) end)
AddButton(tabProtection, L("anti_blind") .. ": " .. L("off"), function(b,c) Settings.Protection.AntiBlind = not Settings.Protection.AntiBlind; b.Text = L("anti_blind") .. ": " .. (Settings.Protection.AntiBlind and L("on") or L("off")); c(Settings.Protection.AntiBlind)
    if Settings.Protection.AntiBlind then for _,v in ipairs(Lighting:GetDescendants()) do if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") then v.Enabled = false end end end
end)
AddButton(tabProtection, L("anti_trap") .. ": " .. L("off"), function(b,c) Settings.Protection.AntiTrap = not Settings.Protection.AntiTrap; b.Text = L("anti_trap") .. ": " .. (Settings.Protection.AntiTrap and L("on") or L("off")); c(Settings.Protection.AntiTrap) end)
AddButton(tabProtection, L("fps_boost"), function(b,c) local r=0; for _,v in ipairs(Workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then v:Destroy(); r=r+1 end end; for _,v in ipairs(Lighting:GetDescendants()) do if v:IsA("BloomEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") then v.Enabled = false; r=r+1 end end; SendNotify("FPS Boost: Removed "..r.." effects"); c(true) end)
AddButton(tabProtection, L("lag_switch") .. ": " .. L("off"), function(b,c) Settings.Protection.LagSwitch = not Settings.Protection.LagSwitch; b.Text = L("lag_switch") .. ": " .. (Settings.Protection.LagSwitch and L("on") or L("off")); c(Settings.Protection.LagSwitch) end)
AddButton(tabProtection, L("anti_grav_change") .. ": " .. L("off"), function(b,c) Settings.Protection.AntiGravChange = not Settings.Protection.AntiGravChange; b.Text = L("anti_grav_change") .. ": " .. (Settings.Protection.AntiGravChange and L("on") or L("off")); c(Settings.Protection.AntiGravChange) end)
AddButton(tabProtection, L("server_crasher") .. ": " .. L("off"), function(b,c) Settings.Protection.ServerCrasher = not Settings.Protection.ServerCrasher; b.Text = L("server_crasher") .. ": " .. (Settings.Protection.ServerCrasher and L("on") or L("off")); c(Settings.Protection.ServerCrasher) end)

-- EXTRA PROTECTION
AddButton(tabProtection, L("ghost_mode") .. ": " .. L("off"), function(b,c) Settings.Protection.GhostMode = not Settings.Protection.GhostMode; b.Text = L("ghost_mode") .. ": " .. (Settings.Protection.GhostMode and L("on") or L("off")); c(Settings.Protection.GhostMode) end)
AddButton(tabProtection, L("admin_detect") .. ": " .. L("off"), function(b,c) Settings.Protection.AdminDetector = not Settings.Protection.AdminDetector; b.Text = L("admin_detect") .. ": " .. (Settings.Protection.AdminDetector and L("on") or L("off")); c(Settings.Protection.AdminDetector) end)

-- NEW SETTINGS/MISC
AddButton(tabMisc, L("chat_spam") .. ": " .. L("off"), function(b,c) Settings.Misc.ChatSpam = not Settings.Misc.ChatSpam; b.Text = L("chat_spam") .. ": " .. (Settings.Misc.ChatSpam and L("on") or L("off")); c(Settings.Misc.ChatSpam) end)
AddSlider(tabMisc, L("spam_delay"), 1, 10, 2, function(v) Settings.Misc.SpamDelay = v end)
AddButton(tabMisc, L("fps_display") .. ": " .. L("off"), function(b,c) Settings.Misc.FPSDisplay = not Settings.Misc.FPSDisplay; b.Text = L("fps_display") .. ": " .. (Settings.Misc.FPSDisplay and L("on") or L("off")); c(Settings.Misc.FPSDisplay) end)
AddButton(tabMisc, L("coords_display") .. ": " .. L("off"), function(b,c) Settings.Misc.CoordsDisplay = not Settings.Misc.CoordsDisplay; b.Text = L("coords_display") .. ": " .. (Settings.Misc.CoordsDisplay and L("on") or L("off")); c(Settings.Misc.CoordsDisplay) end)
AddButton(tabMisc, L("player_join_alert") .. ": " .. L("off"), function(b,c) Settings.Misc.PlayerJoinAlert = not Settings.Misc.PlayerJoinAlert; b.Text = L("player_join_alert") .. ": " .. (Settings.Misc.PlayerJoinAlert and L("on") or L("off")); c(Settings.Misc.PlayerJoinAlert) end)
AddButton(tabMisc, L("instant_respawn") .. ": " .. L("off"), function(b,c) Settings.Misc.InstantRespawn = not Settings.Misc.InstantRespawn; b.Text = L("instant_respawn") .. ": " .. (Settings.Misc.InstantRespawn and L("on") or L("off")); c(Settings.Misc.InstantRespawn) end)
AddButton(tabMisc, L("no_fall_dmg") .. ": " .. L("off"), function(b,c) Settings.Misc.NoFallDmg = not Settings.Misc.NoFallDmg; b.Text = L("no_fall_dmg") .. ": " .. (Settings.Misc.NoFallDmg and L("on") or L("off")); c(Settings.Misc.NoFallDmg) end)
AddButton(tabMisc, L("bring_all"), function(b,c) local ch = LocalPlayer.Character; local h = ch and ch:FindFirstChild("HumanoidRootPart"); if h then for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.CFrame = h.CFrame * CFrame.new(math.random(-5,5),0,math.random(-5,5)) end end end; c(true) end)
AddButton(tabMisc, L("player_count") .. ": " .. L("off"), function(b,c) Settings.Misc.PlayerCount = not Settings.Misc.PlayerCount; b.Text = L("player_count") .. ": " .. (Settings.Misc.PlayerCount and L("on") or L("off")); c(Settings.Misc.PlayerCount) end)
AddButton(tabMisc, L("speed_display") .. ": " .. L("off"), function(b,c) Settings.Misc.SpeedDisplay = not Settings.Misc.SpeedDisplay; b.Text = L("speed_display") .. ": " .. (Settings.Misc.SpeedDisplay and L("on") or L("off")); c(Settings.Misc.SpeedDisplay) end)
AddButton(tabMisc, L("clock_display") .. ": " .. L("off"), function(b,c) Settings.Misc.ClockDisplay = not Settings.Misc.ClockDisplay; b.Text = L("clock_display") .. ": " .. (Settings.Misc.ClockDisplay and L("on") or L("off")); c(Settings.Misc.ClockDisplay) end)
AddButton(tabMisc, L("memory_cleaner") .. ": " .. L("off"), function(b,c) Settings.Misc.MemoryCleaner = not Settings.Misc.MemoryCleaner; b.Text = L("memory_cleaner") .. ": " .. (Settings.Misc.MemoryCleaner and L("on") or L("off")); c(Settings.Misc.MemoryCleaner) end)
AddButton(tabMisc, L("auto_rejoin_kick") .. ": " .. L("off"), function(b,c) Settings.Misc.AutoRejoinKick = not Settings.Misc.AutoRejoinKick; b.Text = L("auto_rejoin_kick") .. ": " .. (Settings.Misc.AutoRejoinKick and L("on") or L("off")); c(Settings.Misc.AutoRejoinKick) end)

-- EXTRA MISC
AddButton(tabMisc, L("item_inspector") .. ": " .. L("off"), function(b,c) Settings.Misc.ItemInspector = not Settings.Misc.ItemInspector; b.Text = L("item_inspector") .. ": " .. (Settings.Misc.ItemInspector and L("on") or L("off")); c(Settings.Misc.ItemInspector) end)
AddButton(tabMisc, L("iy_load"), function(b,c) loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))(); SendNotify("Loaded Infinite Yield"); c(true) end)
AddButton(tabMisc, L("dex_load"), function(b,c) loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))(); SendNotify("Loaded DEX Explorer"); c(true) end)
AddButton(tabMisc, L("remote_spy"), function(b,c) loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))(); SendNotify("Loaded SimpleSpy V3"); c(true) end)

-- Bind Manager
AddBindButton(tabBinds, L("bind_menu"), "Menu")
AddBindButton(tabBinds, L("bind_fly"), "Fly")
AddBindButton(tabBinds, L("bind_panic"), "Panic")
AddBindButton(tabBinds, L("bind_tp_mouse"), "TPMouse")

-- Theme Editor
for _, themeName in ipairs({"Default", "Neon", "Terminal", "Toxic", "Clean"}) do
    AddButton(tabTheme, L("theme_" .. string.lower(themeName)), function(b, c)
        ApplyTheme(themeName)
        c(true)
    end)
end

SelectTab(L("tab_visuals"))

-- // INPUTS
UserInputService.InputBegan:Connect(function(input, gp)
    -- Bind listening mode
    if listeningBind and input.KeyCode ~= Enum.KeyCode.Unknown then
        UserBinds[listeningBind.key] = input.KeyCode
        listeningBind.btn.Text = listeningBind.label .. ": " .. input.KeyCode.Name
        TweenService:Create(listeningBind.btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(12, 12, 30)}):Play()
        SendNotify(string.format(L("notify_bind_set"), listeningBind.label, input.KeyCode.Name))
        listeningBind = nil
        return
    end
    if not gp then
        if input.KeyCode == Enum.KeyCode.W then FlyVars.ctrl.f = -1
        elseif input.KeyCode == Enum.KeyCode.S then FlyVars.ctrl.b = 1
        elseif input.KeyCode == Enum.KeyCode.A then FlyVars.ctrl.l = -1
        elseif input.KeyCode == Enum.KeyCode.D then FlyVars.ctrl.r = 1
        elseif input.KeyCode == Enum.KeyCode.Space then FlyVars.ctrl.u = 1
        elseif input.KeyCode == Enum.KeyCode.LeftShift then FlyVars.ctrl.d = -1
        elseif input.KeyCode == UserBinds.Menu then 
            if mainFrame.Visible then
                TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 680, 0, 10), BackgroundTransparency = 1}):Play()
                task.delay(0.25, function() mainFrame.Visible = false; mainFrame.Size = UDim2.new(0, 700, 0, 480); mainFrame.BackgroundTransparency = 0.08 end)
            else
                mainFrame.Size = UDim2.new(0, 700, 0, 10); mainFrame.BackgroundTransparency = 1; mainFrame.Visible = true
                TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 700, 0, 480), BackgroundTransparency = 0.08}):Play()
            end
            playerWindow.Visible = false
        elseif input.KeyCode == UserBinds.Panic then 
            mainFrame.Visible = false
            playerWindow.Visible = false
            Settings.ESP.Enabled = false
            Settings.Aimbot.Enabled = false
        elseif input.KeyCode == UserBinds.Fly and UserBinds.Fly ~= Enum.KeyCode.Unknown then
            Settings.Movement.Fly = not Settings.Movement.Fly
        elseif input.KeyCode == UserBinds.TPMouse and Settings.Movement.TPtoMouse then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local mouseHit = Mouse.Hit
                if mouseHit then
                    hrp.CFrame = mouseHit + Vector3.new(0, 3, 0)
                end
            end
        end
    end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then isRmbDown = true end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isLmbDown = true end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if not gp then
        if input.KeyCode == Enum.KeyCode.W then FlyVars.ctrl.f = 0
        elseif input.KeyCode == Enum.KeyCode.S then FlyVars.ctrl.b = 0
        elseif input.KeyCode == Enum.KeyCode.A then FlyVars.ctrl.l = 0
        elseif input.KeyCode == Enum.KeyCode.D then FlyVars.ctrl.r = 0
        elseif input.KeyCode == Enum.KeyCode.Space then FlyVars.ctrl.u = 0
        elseif input.KeyCode == Enum.KeyCode.LeftShift then FlyVars.ctrl.d = 0
        end
    end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then isRmbDown = false end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isLmbDown = false end
end)

UserInputService.JumpRequest:Connect(function()
    if Settings.Movement.InfJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function() hum.UseJumpPower = true end)
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local function ExpandPart(part, targetSize, transparency)
    if not part:GetAttribute("OrigSize") then part:SetAttribute("OrigSize", part.Size) end
    part.Size = Vector3.new(targetSize, targetSize, targetSize)
    part.Transparency = transparency
    part.Massless = true
    part.CanCollide = false
    part.CanQuery = true
end

local function RestorePart(part)
    local origSize = part:GetAttribute("OrigSize")
    if origSize and part.Size ~= origSize then
        part.Size = origSize
        part.Transparency = 0
        part.Massless = false
        part.CanQuery = true
    end
end

local function CalcHitboxSize(baseSize, origS, dist, shrinkDist)
    if not Settings.Hitbox.ProximityShrink then return baseSize end
    local t = math.clamp(dist / shrinkDist, 0, 1)
    return origS + (baseSize - origS) * t
end

local function UpdateHitboxes()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    -- PLAYERS
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char then continue end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        
        if Settings.Hitbox.Enabled and IsEnemy(player) then
            local dist = 9999
            if myRoot then
                local eRoot = char:FindFirstChild("HumanoidRootPart")
                if eRoot then dist = (eRoot.Position - myRoot.Position).Magnitude end
            end
            
            -- Expand Head
            local head = char:FindFirstChild("Head")
            if head and head:IsA("BasePart") then
                if not head:GetAttribute("OrigSize") then head:SetAttribute("OrigSize", head.Size) end
                local origS = head:GetAttribute("OrigSize") and head:GetAttribute("OrigSize").X or 1.2
                local targetSize = CalcHitboxSize(Settings.Hitbox.Size, origS, dist, Settings.Hitbox.ShrinkDist)
                ExpandPart(head, targetSize, Settings.Hitbox.Transparency)
            end
            
            -- Expand ALL parts (for Rivals and similar games)
            if Settings.Hitbox.ExpandAllParts then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "Head" and part.Name ~= "HumanoidRootPart" then
                        if not part:GetAttribute("OrigSize") then part:SetAttribute("OrigSize", part.Size) end
                        local origS = part:GetAttribute("OrigSize") and part:GetAttribute("OrigSize").X or 1
                        local partScale = Settings.Hitbox.Size * 0.7
                        local targetSize = CalcHitboxSize(partScale, origS, dist, Settings.Hitbox.ShrinkDist)
                        ExpandPart(part, targetSize, Settings.Hitbox.Transparency)
                    end
                end
            end
        else
            -- Restore all parts
            local head = char:FindFirstChild("Head")
            if head and head:IsA("BasePart") then RestorePart(head) end
            if Settings.Hitbox.ExpandAllParts then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "Head" and part.Name ~= "HumanoidRootPart" then
                        RestorePart(part)
                    end
                end
            end
        end
    end
    -- ENTITIES (NPCs / Mobs)
    if Settings.Hitbox.EntityHitbox then
        for _, model in ipairs(Workspace:GetChildren()) do
            if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(model) then
                local head = model:FindFirstChild("Head")
                local hum = model:FindFirstChildOfClass("Humanoid")
                if head and head:IsA("BasePart") and hum and hum.Health > 0 then
                    if not head:GetAttribute("OrigSize") then head:SetAttribute("OrigSize", head.Size) end
                    local dist = 9999
                    if myRoot then
                        local eRoot = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
                        if eRoot then dist = (eRoot.Position - myRoot.Position).Magnitude end
                    end
                    local origS = head:GetAttribute("OrigSize") and head:GetAttribute("OrigSize").X or 1.2
                    local targetSize = CalcHitboxSize(Settings.Hitbox.EntitySize, origS, dist, Settings.Hitbox.ShrinkDist)
                    ExpandPart(head, targetSize, Settings.Hitbox.Transparency)
                end
            end
        end
    end
end

local espTickCounter = 0
local nextTriggerTime = 0
local fpsFrameCount = 0
local fpsLastTime = tick()
RunService.RenderStepped:Connect(function()
    -- FPS tracking for Performance Guard
    fpsFrameCount = fpsFrameCount + 1
    local now = tick()
    if now - fpsLastTime >= 1 then
        currentFPS = fpsFrameCount
        fpsFrameCount = 0
        fpsLastTime = now
        if Settings.PerfGuard.Enabled then
            if currentFPS < Settings.PerfGuard.MinFPS and not perfGuardTriggered then
                perfGuardTriggered = true
                Settings.ESP.GlowEffect = false
                Settings.ESP.RainbowChams = false
                Settings.ESP.DmgIndicator = false
                SendNotify(L("notify_perf_triggered"))
            elseif currentFPS >= Settings.PerfGuard.MinFPS + 10 then
                perfGuardTriggered = false
            end
        end
    end

    espTickCounter = espTickCounter + 1
    if espTickCounter >= 5 then
        espTickCounter = 0
        UpdateESP()
        UpdateHitboxes()
    end
    
    local mLoc = UserInputService:GetMouseLocation()
    if supportDrawing then
        fovCircle.Position = mLoc; fovCircle.Radius = Settings.Aimbot.Radius; fovCircle.Visible = Settings.Aimbot.ShowFOV
        if Settings.ESP.Crosshair then
            chL.Visible = true; chR.Visible = true; chT.Visible = true; chB.Visible = true
            chL.From = Vector2.new(mLoc.X - 12, mLoc.Y); chL.To = Vector2.new(mLoc.X - 4, mLoc.Y)
            chR.From = Vector2.new(mLoc.X + 4, mLoc.Y); chR.To = Vector2.new(mLoc.X + 12, mLoc.Y)
            chT.From = Vector2.new(mLoc.X, mLoc.Y - 12); chT.To = Vector2.new(mLoc.X, mLoc.Y - 4)
            chB.From = Vector2.new(mLoc.X, mLoc.Y + 4); chB.To = Vector2.new(mLoc.X, mLoc.Y + 12)
        else
            chL.Visible = false; chR.Visible = false; chT.Visible = false; chB.Visible = false
        end
    else
        fovCircle.Size = UDim2.new(0, Settings.Aimbot.Radius * 2, 0, Settings.Aimbot.Radius * 2); fovCircle.Position = UDim2.new(0, mLoc.X - Settings.Aimbot.Radius, 0, mLoc.Y - Settings.Aimbot.Radius); fovCircle.Visible = Settings.Aimbot.ShowFOV
        if Settings.ESP.Crosshair then
            chL.Visible = true; chR.Visible = true; chT.Visible = true; chB.Visible = true
            chL.Size = UDim2.new(0, 8, 0, 2); chL.Position = UDim2.new(0, mLoc.X - 12, 0, mLoc.Y - 1)
            chR.Size = UDim2.new(0, 8, 0, 2); chR.Position = UDim2.new(0, mLoc.X + 4, 0, mLoc.Y - 1)
            chT.Size = UDim2.new(0, 2, 0, 8); chT.Position = UDim2.new(0, mLoc.X - 1, 0, mLoc.Y - 12)
            chB.Size = UDim2.new(0, 2, 0, 8); chB.Position = UDim2.new(0, mLoc.X - 1, 0, mLoc.Y + 4)
        else
            chL.Visible = false; chR.Visible = false; chT.Visible = false; chB.Visible = false
        end
    end

    if Settings.Combat.TriggerBot and tick() > nextTriggerTime then
        local target = Mouse.Target
        if target and target.Parent and target.Parent:FindFirstChild("Humanoid") then
            local enemyPlayer = Players:GetPlayerFromCharacter(target.Parent)
            if enemyPlayer and enemyPlayer ~= LocalPlayer and IsEnemy(enemyPlayer) then
                nextTriggerTime = tick() + Settings.Combat.TriggerBotDelay
                task.spawn(function()
                    pcall(function() 
                        if mouse1click then 
                            mouse1click() 
                        else 
                            VirtualUser:Button1Down(Vector2.new(0,0))
                            task.wait(0.02)
                            VirtualUser:Button1Up(Vector2.new(0,0)) 
                        end 
                    end)
                end)
            end
        end
    end

    if Settings.World.LowGravity then Workspace.Gravity = Settings.World.GravityVal end
    if Settings.World.TimeOfDayOn then Lighting.ClockTime = Settings.World.TimeOfDay end

    if Settings.Aimbot.Enabled and isRmbDown then
        local target, part = GetClosestTarget()
        if part then
            local aimPos = part.Position
            if Settings.Aimbot.Prediction and part.Parent:FindFirstChild("HumanoidRootPart") then
                aimPos = aimPos + (part.Parent.HumanoidRootPart.AssemblyLinearVelocity * Settings.Aimbot.PredictFactor)
            end
            if Settings.Aimbot.SilentAim then
                -- Silent Aim: snap camera instantly to target (invisible to player, hits register)
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPos)
            else
                local pos = Camera:WorldToViewportPoint(aimPos)
                local dx = (pos.X - mLoc.X)
                local dy = (pos.Y - mLoc.Y)
                if typeof(mousemoverel) == "function" then mousemoverel(dx / Settings.Aimbot.Smoothing, dy / Settings.Aimbot.Smoothing)
                else Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, part.Position), 1 / Settings.Aimbot.Smoothing) end
            end
        end
    end

    -- No Recoil
    if Settings.Combat.NoRecoil then
        local char = LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BodyAngularVelocity") or v:IsA("BodyThrust") then v:Destroy() end
            end
        end
    end

    -- LOOP TP (instant teleport, zero velocity on all axes to prevent skin floating)
    if Settings.TP.LoopTP and Settings.TP.TargetPlayer then
        local tChar = Settings.TP.TargetPlayer.Character
        local myChar = LocalPlayer.Character
        if tChar and myChar and tChar:FindFirstChild("HumanoidRootPart") and myChar:FindFirstChild("HumanoidRootPart") then
            local targetCF = tChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            myChar.HumanoidRootPart.CFrame = targetCF
            myChar.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            myChar.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
            -- Anchor briefly then unanchor to force network sync
            myChar.HumanoidRootPart.Velocity = Vector3.zero
        end
    end

    -- Persistent Spectate (survives target death/respawn) + TP character to target so skin doesn't float behind
    if Settings.TP.Spectating and Settings.TP.SpectateTarget then
        local specTarget = Settings.TP.SpectateTarget
        if specTarget.Parent then
            if specTarget.Character then
                local specHum = specTarget.Character:FindFirstChildOfClass("Humanoid")
                if specHum then
                    Camera.CameraSubject = specHum
                end
                -- Teleport our character to spectate target so our skin doesn't float away
                local myChar = LocalPlayer.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local specRoot = specTarget.Character:FindFirstChild("HumanoidRootPart")
                if myRoot and specRoot then
                    myRoot.CFrame = specRoot.CFrame
                    myRoot.AssemblyLinearVelocity = Vector3.zero
                    myRoot.AssemblyAngularVelocity = Vector3.zero
                    myRoot.Velocity = Vector3.zero
                end
            end
        else
            Settings.TP.Spectating = false
            Settings.TP.SpectateTarget = nil
            spectateUIBtn.Text = L("spectate")
            spectateUIBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 30)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            end
        end
    end

    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")
        if Settings.Movement.Noclip then for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end end
        if Settings.Rage.Spinbot then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(50), 0) end
        -- Anti-Aim: desync head so enemy aimbots target wrong position
        if Settings.Rage.AntiAim then
            local head = char:FindFirstChild("Head")
            if head then
                local offset = CFrame.new(0, math.sin(tick() * 15) * 2.5, math.cos(tick() * 12) * 2)
                head.CFrame = hrp.CFrame * CFrame.new(0, 1.5, 0) * offset
            end
        end
        if Settings.Movement.Fly then
            if hum then hum.PlatformStand = true end
            if not FlyVars.bg then FlyVars.bg = Instance.new("BodyGyro", hrp); FlyVars.bg.P = 9e4; FlyVars.bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); FlyVars.bg.cframe = hrp.CFrame end
            if not FlyVars.bv then FlyVars.bv = Instance.new("BodyVelocity", hrp); FlyVars.bv.velocity = Vector3.zero; FlyVars.bv.maxForce = Vector3.new(9e9, 9e9, 9e9) end
            local ct = FlyVars.ctrl
            local moveDir = Vector3.new(ct.l + ct.r, ct.d + ct.u, ct.f + ct.b)
            if moveDir.Magnitude > 0 then FlyVars.bv.velocity = Camera.CFrame:VectorToWorldSpace(moveDir).Unit * Settings.Movement.Speed
            else FlyVars.bv.velocity = Vector3.zero end; FlyVars.bg.cframe = Camera.CFrame
        else
            if hum then hum.PlatformStand = false end
            if FlyVars.bg then FlyVars.bg:Destroy() FlyVars.bg = nil end
            if FlyVars.bv then FlyVars.bv:Destroy() FlyVars.bv = nil end
        end
        -- BHop
        if Settings.Movement.BHop then
            if hum and hum:GetState() == Enum.HumanoidStateType.Running and hum.MoveDirection.Magnitude > 0 then
                pcall(function() hum.UseJumpPower = true end)
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
        -- JumpPower Hack
        if Settings.Movement.JumpPowerOn then
            if hum then pcall(function() hum.UseJumpPower = true end); hum.JumpPower = Settings.Movement.JumpPowerVal end
        end
        -- CFrame Speed (undetectable speed)
        if Settings.Movement.CFrameSpeed then
            if hum and hum.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + hum.MoveDirection * Settings.Movement.CFrameSpeedVal
            end
        end
        -- WalkSpeed Hack
        if Settings.Movement.WalkSpeedOn then
            if hum then hum.WalkSpeed = Settings.Movement.WalkSpeedVal end
        end
        -- Lag Speed (ping lag effect - ultra laggy)
        if Settings.Movement.LagSpeed then
            lagSpeedCounter = lagSpeedCounter + 1
            if lagSpeedCounter >= lagSpeedNextTick then
                lagSpeedCounter = 0
                lagSpeedNextTick = math.random(1, 3)
                if hum and hum.MoveDirection.Magnitude > 0 then
                    local roll = math.random()
                    local lagDist
                    if roll < 0.2 then
                        lagDist = Settings.Movement.LagSpeedVal * (5 + math.random() * 8)
                    elseif roll < 0.5 then
                        lagDist = Settings.Movement.LagSpeedVal * (2 + math.random() * 5)
                    else
                        lagDist = Settings.Movement.LagSpeedVal * (1 + math.random() * 3)
                    end
                    local sideJitter = (math.random() - 0.5) * Settings.Movement.LagSpeedVal * 0.8
                    local yJitter = (math.random() - 0.3) * Settings.Movement.LagSpeedVal * 0.15
                    local moveDir = hum.MoveDirection
                    local sideDir = Vector3.new(-moveDir.Z, 0, moveDir.X)
                    hrp.CFrame = hrp.CFrame + moveDir * lagDist + sideDir * sideJitter + Vector3.new(0, yJitter, 0)
                    if roll < 0.15 then
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end
        -- Anti-Void
        if Settings.Movement.AntiVoid and hrp.Position.Y < -50 then
            hrp.CFrame = CFrame.new(hrp.Position.X, 100, hrp.Position.Z)
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
        -- Spider (wall climbing)
        if Settings.Movement.Spider then
            local rayDown = Workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 3, RaycastParams.new())
            if rayDown and rayDown.Instance then
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 1.2, 0)
            end
        end
        -- Anti-Knockback
        if Settings.Movement.AntiKnockback then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, hrp.AssemblyLinearVelocity.Y, hrp.AssemblyLinearVelocity.Z)
            local vel = hrp.AssemblyLinearVelocity
            if vel.Magnitude > 60 then
                hrp.AssemblyLinearVelocity = vel.Unit * 20
            end
        end

        -- ===== NEW MOVEMENT LOGIC =====
        -- Glide (slow fall)
        if Settings.Movement.Glide and hum then
            local vel = hrp.AssemblyLinearVelocity
            if vel.Y < -Settings.Movement.GlideSpeed then
                hrp.AssemblyLinearVelocity = Vector3.new(vel.X, -Settings.Movement.GlideSpeed, vel.Z)
            end
        end
        -- Freeze Position
        if Settings.Movement.FreezePos then
            hrp.Anchored = true
        else
            if hrp.Anchored and not Settings.Movement.Fly then hrp.Anchored = false end
        end
        -- Auto Walk
        if Settings.Movement.AutoWalk and hum then
            hum:Move(Vector3.new(0, 0, -1), true)
        end
        -- Auto Sprint
        if Settings.Movement.AutoSprint and hum then
            hum.WalkSpeed = math.max(hum.WalkSpeed, 20)
        end
        -- Step (climb small walls)
        if Settings.Movement.StepOn and hum then
            hum.MaxSlopeAngle = 89.9
        end
        -- Speed Pulse
        if Settings.Movement.SpeedPulse and hum then
            local t = tick() % 2
            hum.WalkSpeed = t < 1 and Settings.Movement.SpeedPulseMax or Settings.Movement.SpeedPulseMin
        end
        -- Bunny Fly (hop-style fly)
        if Settings.Movement.BunnyFly and hum then
            if hum:GetState() ~= Enum.HumanoidStateType.Freefall then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 30, hrp.AssemblyLinearVelocity.Z)
        end
        -- Phase (thin wall clip)
        if Settings.Movement.Phase and hum then
            for _,v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        -- Safe Walk (no edge falling)
        if Settings.Movement.SafeWalk and hum then
            local rayDown = Workspace:Raycast(hrp.Position + hrp.CFrame.LookVector * 3, Vector3.new(0, -10, 0), RaycastParams.new())
            if not rayDown then
                hum:Move(Vector3.zero)
            end
        end
        -- Follow Player
        if Settings.Movement.FollowPlayer and Settings.TP.TargetPlayer and Settings.TP.TargetPlayer.Character and Settings.TP.TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local target = Settings.TP.TargetPlayer.Character.HumanoidRootPart
            local dir = (target.Position - hrp.Position)
            if dir.Magnitude > 5 then
                hum:Move(dir.Unit)
            end
        end
        -- Orbit Player
        if Settings.Movement.OrbitPlayer and Settings.TP.TargetPlayer and Settings.TP.TargetPlayer.Character and Settings.TP.TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local target = Settings.TP.TargetPlayer.Character.HumanoidRootPart
            local angle = tick() * Settings.Movement.OrbitSpeed
            local offset = Vector3.new(math.cos(angle) * Settings.Movement.OrbitRadius, 0, math.sin(angle) * Settings.Movement.OrbitRadius)
            hrp.CFrame = CFrame.new(target.Position + offset, target.Position)
        end
        -- Invisible Platform
        if Settings.Movement.InvPlatform then
            local existing = Workspace:FindFirstChild("_InvPlatform_")
            if not existing then
                local p = Instance.new("Part", Workspace)
                p.Name = "_InvPlatform_"; p.Size = Vector3.new(6,1,6); p.Transparency = 1; p.Anchored = true; p.CanCollide = true
                p.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3, hrp.Position.Z)
            else
                existing.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3, hrp.Position.Z)
            end
        else
            local existing = Workspace:FindFirstChild("_InvPlatform_")
            if existing then existing:Destroy() end
        end
        -- Jesus Walk (water walk)
        if Settings.Movement.JesusWalk and hum then
            local rayDown = Workspace:Raycast(hrp.Position, Vector3.new(0, -10, 0), RaycastParams.new())
            if not rayDown or hrp.Position.Y < 5 then
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, math.max(hrp.AssemblyLinearVelocity.Y, 0), hrp.AssemblyLinearVelocity.Z)
            end
        end
        -- Slide
        if Settings.Movement.SlideOn and hum then
            if hum:GetState() == Enum.HumanoidStateType.Running then
                hum.HipHeight = -1.5
            end
        else
            if hum and hum.HipHeight < 0 then hum.HipHeight = 0 end
        end

        -- ===== NEW COMBAT LOGIC =====
        -- Rapid Fire
        if Settings.Combat.RapidFire then
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                pcall(function() mouse1click() end)
            end
        end
        -- Target Strafe
        if Settings.Combat.TargetStrafe and Settings.TP.TargetPlayer and Settings.TP.TargetPlayer.Character and Settings.TP.TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local target = Settings.TP.TargetPlayer.Character.HumanoidRootPart
            local angle = tick() * Settings.Combat.StrafeSpeed
            local offset = Vector3.new(math.cos(angle) * Settings.Combat.StrafeRadius, 0, math.sin(angle) * Settings.Combat.StrafeRadius)
            hrp.CFrame = CFrame.new(target.Position + offset, target.Position)
        end
        -- Auto Backstab
        if Settings.Combat.AutoBackstab and Settings.TP.TargetPlayer and Settings.TP.TargetPlayer.Character then
            local targetChar = Settings.TP.TargetPlayer.Character
            local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local behindPos = targetHRP.CFrame * CFrame.new(0, 0, 3)
                hrp.CFrame = CFrame.new(behindPos.Position, targetHRP.Position)
            end
        end

        -- ===== NEW VISUAL LOGIC =====
        -- Night Vision
        if Settings.ESP.NightVision then
            Lighting.Ambient = Color3.fromRGB(0, 200, 0)
            Lighting.Brightness = 3
            Lighting.FogEnd = 99999
        end
        -- No Fog
        if Settings.ESP.NoFog then
            Lighting.FogEnd = 99999
            Lighting.FogStart = 99999
        end
        -- No Shadows
        if Settings.ESP.NoShadows then
            Lighting.GlobalShadows = false
        end
        -- Third Person
        if Settings.ESP.ThirdPerson then
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = Settings.ESP.ThirdPersonDist
            LocalPlayer.CameraMinZoomDistance = Settings.ESP.ThirdPersonDist
        end

        -- ===== NEW WORLD LOGIC =====
        -- Auto Day/Night
        if Settings.World.AutoDayNight then
            Lighting.ClockTime = (Lighting.ClockTime + 0.01) % 24
        end
        -- World Freeze
        if Settings.World.WorldFreeze then
            for _,v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("AnimationController") or v:IsA("Animator") then
                    pcall(function() v:GetPlayingAnimationTracks()[1]:Stop() end)
                end
            end
        end
        -- No Camera Shake
        if Settings.World.NoCamShake then
            pcall(function()
                local shake = Camera:FindFirstChildOfClass("Script")
                if shake then shake.Disabled = true end
            end)
        end
        -- Remove Particles (loop)
        if Settings.World.RemoveParticles then
            for _,v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                    v:Destroy()
                end
            end
        end
        -- Big Head
        if Settings.World.BigHead then
            for _,p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    p.Character.Head.Size = Vector3.new(Settings.World.BigHeadSize, Settings.World.BigHeadSize, Settings.World.BigHeadSize)
                end
            end
        end
        -- Small Players
        if Settings.World.SmallPlayers then
            for _,p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    pcall(function()
                        local hum2 = p.Character:FindFirstChildOfClass("Humanoid")
                        if hum2 then hum2.BodyDepthScale.Value = Settings.World.SmallScale; hum2.BodyWidthScale.Value = Settings.World.SmallScale; hum2.BodyHeightScale.Value = Settings.World.SmallScale; hum2.HeadScale.Value = Settings.World.SmallScale end
                    end)
                end
            end
        end
        -- Custom Ambient
        if Settings.World.CustomAmbient then
            Lighting.Ambient = Color3.fromRGB(Settings.World.AmbientR, Settings.World.AmbientG, Settings.World.AmbientB)
        end
        -- Bright Players
        if Settings.ESP.BrightPlayers then
            for _,p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    for _,v in ipairs(p.Character:GetDescendants()) do
                        if v:IsA("BasePart") then v.Material = Enum.Material.Neon end
                    end
                end
            end
        end

        -- ===== PROTECTION LOGIC =====
        -- Anti-Fling
        if Settings.Protection.AntiFling then
            local vel = hrp.AssemblyLinearVelocity
            if vel.Magnitude > 100 then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
        end
        -- Anti-Slow
        if Settings.Protection.AntiSlow and hum then
            if hum.WalkSpeed < 16 then hum.WalkSpeed = 16 end
        end
        -- Anti-Gravity Change
        if Settings.Protection.AntiGravChange then
            if Workspace.Gravity ~= 196.2 and not Settings.World.LowGravity then
                Workspace.Gravity = 196.2
            end
        end
        -- Lag Switch
        if Settings.Protection.LagSwitch then
            settings().Network.IncomingReplicationLag = 1
        else
            pcall(function() settings().Network.IncomingReplicationLag = 0 end)
        end
        -- No Fall Damage
        if Settings.Misc.NoFallDmg and hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end

        -- ===== V2 LOGIC INJECTIONS (RENDERSTEPPED) =====
        -- Movement V2
        if Settings.Movement.Hover and hrp then hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z) end
        if Settings.Movement.SpaceJump and hum and UserInputService:IsKeyDown(Enum.KeyCode.Space) then hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 150, hrp.AssemblyLinearVelocity.Z) end
        if Settings.Movement.FlipGravity and hrp then Workspace.Gravity = -196.2 elseif not Settings.World.LowGravity then Workspace.Gravity = 196.2 end
        if Settings.Movement.AutoJump and hum and UserInputService:IsKeyDown(Enum.KeyCode.Space) then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        if Settings.Movement.FakeLagV1 and hrp then hrp.Anchored = (tick() % 0.5 < 0.25) end
        if Settings.Movement.VehicleFly and hum then local sit = hum.SeatPart; if sit and sit.Parent then sit.Parent:PivotTo(sit.Parent:GetPivot() + Vector3.new(0, 1, 0)) end end
        if Settings.Movement.ReverseWalk and hum and hum.MoveDirection.Magnitude > 0 then hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position - hum.MoveDirection) end
        
        -- Combat V2
        if Settings.Combat.MeleeAura and hrp then for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 15 then pcall(function() mouse1click() end) end end end
        if Settings.Combat.MagnetAimbot and Settings.TP.TargetPlayer and Settings.TP.TargetPlayer.Character and Settings.TP.TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then local t = Settings.TP.TargetPlayer.Character.HumanoidRootPart; for _, v in ipairs(Workspace:GetChildren()) do if (v.Name == "Bullet" or v.Name == "Arrow") and v:IsA("Part") then v.CFrame = CFrame.lookAt(v.Position, t.Position) end end end
        if Settings.Combat.KeepDistance and Settings.TP.TargetPlayer and Settings.TP.TargetPlayer.Character and Settings.TP.TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then local t = Settings.TP.TargetPlayer.Character.HumanoidRootPart; if (t.Position - hrp.Position).Magnitude < 15 then hrp.CFrame = hrp.CFrame * CFrame.new(0,0,5) end end
        if Settings.Combat.HitboxExtenderArms then for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then for _,v in ipairs(p.Character:GetChildren()) do if v:IsA("BasePart") and (string.find(v.Name, "Arm") or string.find(v.Name, "Leg")) then v.Size = Vector3.new(3,3,3) end end end end end
        
        -- ESP/Visuals V2
        if Settings.ESP.ChamsMaterial ~= "Neon" and Settings.ESP.Chams then for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then for _,v in ipairs(p.Character:GetDescendants()) do if v:IsA("BasePart") then pcall(function() v.Material = Enum.Material[Settings.ESP.ChamsMaterial] end) end end end end end
        if Settings.ESP.TargetHighlight and Settings.TP.TargetPlayer and Settings.TP.TargetPlayer.Character then local target = Settings.TP.TargetPlayer.Character; if not target:FindFirstChild("Highlight") then local h = Instance.new("Highlight", target); h.FillColor = Color3.new(1,1,0) end end
        if Settings.ESP.TargetHighlight == false and Settings.TP.TargetPlayer then local tc = Settings.TP.TargetPlayer.Character; if tc and tc:FindFirstChild("Highlight") then for _, h in ipairs(tc:GetChildren()) do if h:IsA("Highlight") and h.Name == "Highlight" and h.FillColor == Color3.new(1,1,0) then h:Destroy() end end end end
        if Settings.ESP.WallHackV2 then for _,v in ipairs(Workspace:GetDescendants()) do if v:IsA("BasePart") and v.Transparency == 0 and not Players:GetPlayerFromCharacter(v.Parent) then v.Transparency = 0.5 end end end
        
        -- World V2
        if Settings.World.ClearWeather then pcall(function() Workspace.Terrain.Clouds.Enabled = false end); Lighting.FogEnd = 99999 end
        if Settings.World.NoTextures then for _,v in ipairs(Workspace:GetDescendants()) do if v:IsA("BasePart") and not Players:GetPlayerFromCharacter(v.Parent) then v.Material = Enum.Material.SmoothPlastic end end end
        if Settings.World.DarkMode then Lighting.Ambient = Color3.new(0,0,0); Lighting.Brightness = 0; Lighting.OutdoorAmbient = Color3.new(0,0,0) end
        if Settings.World.BouncyWorld then for _,v in ipairs(Workspace:GetDescendants()) do if v:IsA("BasePart") and not Players:GetPlayerFromCharacter(v.Parent) then v.CustomPhysicalProperties = PhysicalProperties.new(0.5, 0.3, 1, 1, 1) end end end
        if Settings.World.SlipperyWorld then for _,v in ipairs(Workspace:GetDescendants()) do if v:IsA("BasePart") and not Players:GetPlayerFromCharacter(v.Parent) then v.CustomPhysicalProperties = PhysicalProperties.new(0.5, 0, 0, 1, 1) end end end
        
        -- Protection V2
        if Settings.Protection.GhostMode and hrp then hrp.Transparency = 1; for _,v in ipairs(char:GetDescendants()) do if v:IsA("BasePart") then v.Transparency = 1 end end end
        if Settings.Protection.NoClipV2 and hrp then for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end

end)

-- ===== BACKGROUND THREADS =====
-- Chat Spam
task.spawn(function()
    while task.wait(1) do
        if Settings.Misc.ChatSpam then
            pcall(function()
                local ts = game:GetService("TextChatService")
                local ch = ts.TextChannels:FindFirstChild("RBXGeneral")
                if ch then ch:SendAsync(Settings.Misc.SpamText) end
            end)
            task.wait(Settings.Misc.SpamDelay)
        end
    end
end)

-- Player Join Alert
Players.PlayerAdded:Connect(function(p)
    if Settings.Misc.PlayerJoinAlert then
        SendNotify("🔔 Player Joined: " .. p.Name)
    end
end)

-- Instant Respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    if Settings.Misc.InstantRespawn then
        task.wait(0.1)
        pcall(function()
            local hum = char:WaitForChild("Humanoid", 3)
            if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        end)
    end
    -- Restore movement settings after respawn
    if Settings.Config.AutoRespawn then
        task.wait(1)
        pcall(function()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and Settings.Movement.WalkSpeedOn then hum.WalkSpeed = Settings.Movement.WalkSpeedVal end
            if hum and Settings.Movement.JumpPowerOn then hum.JumpPower = Settings.Movement.JumpPowerVal end
            SendNotify(L("notify_auto_respawn"))
        end)
    end
end)

-- Memory Cleaner
task.spawn(function()
    while task.wait(30) do
        if Settings.Misc.MemoryCleaner then
            pcall(function() collectgarbage("collect") end)
        end
    end
end)

-- Moon Jump (separate thread)
UserInputService.JumpRequest:Connect(function()
    local char = LocalPlayer.Character
    if char and Settings.Movement.MoonJump then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 80, hrp.AssemblyLinearVelocity.Z)
        end
    end
    -- Long Jump
    if char and Settings.Movement.LongJump then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * Settings.Movement.LongJumpPower + Vector3.new(0, 30, 0)
        end
    end
    -- High Jump
    if char and Settings.Movement.HighJump then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, Settings.Movement.HighJumpPower, hrp.AssemblyLinearVelocity.Z)
        end
    end
end)

-- Dash (key Q)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Q and Settings.Movement.Dash then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * Settings.Movement.DashPower + Vector3.new(0, 15, 0)
        end
    end
end)

-- Server Crasher (loop)
task.spawn(function()
    while task.wait(0.1) do
        if Settings.Protection.ServerCrasher then
            pcall(function()
                for i = 1, 50 do
                    Instance.new("Part", Workspace).Size = Vector3.new(999,999,999)
                end
            end)
        end
    end
end)

-- Anti-Blind (continuous)
task.spawn(function()
    while task.wait(1) do
        if Settings.Protection.AntiBlind then
            for _,v in ipairs(Lighting:GetDescendants()) do
                if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") then v.Enabled = false end
            end
        end
    end
end)

-- Anti-Trap (continuous)
task.spawn(function()
    while task.wait(2) do
        if Settings.Protection.AntiTrap then
            local char = LocalPlayer.Character
            if char then
                for _,v in ipairs(char:GetDescendants()) do
                    if v:IsA("Weld") and v.Name ~= "RootJoint" and v.Name ~= "Motor6D" and not v.Parent:IsA("BasePart") then
                        pcall(function() v:Destroy() end)
                    end
                end
            end
        end
    end
end)

-- Anti-Teleport (block server TPs)
task.spawn(function()
    if Settings.Protection.AntiTP then
        pcall(function()
            local ts = game:GetService("TeleportService")
            ts.TeleportInitFailed:Connect(function() end)
        end)
    end
end)

-- Kill Aura (background)
task.spawn(function()
    while task.wait(0.2) do
        if Settings.Combat.KillAura then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _,p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
                        local dist = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if dist <= Settings.Combat.KillAuraRange then
                            pcall(function()
                                local tool = char:FindFirstChildOfClass("Tool")
                                if tool then tool:Activate() end
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- Auto-Rejoin on Kick
pcall(function()
    if Settings.Misc.AutoRejoinKick then
        game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function()
            pcall(function()
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end)
        end)
    end
end)

-- Item Inspector: Press T to see the name/class of the object under mouse
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.T and Settings.Misc.ItemInspector then
        local target = Mouse.Target
        if target then
            local name = target.Name
            local class = target.ClassName
            local parent = target.Parent and target.Parent.Name or "nil"
            -- Check if it's a Tool or inside a Tool
            local tool = target:FindFirstAncestorOfClass("Tool")
            local toolName = tool and (" | Tool: " .. tool.Name) or ""
            -- Check if it's a Model
            local model = target:FindFirstAncestorOfClass("Model")
            local modelName = model and (" | Model: " .. model.Name) or ""
            local info = string.format("Name: %s | Class: %s | Parent: %s%s%s", name, class, parent, toolName, modelName)
            SendNotify("🔍 " .. info)
            -- Show BillboardGui on the object briefly
            pcall(function()
                local bbg = Instance.new("BillboardGui")
                bbg.Name = "ItemInspectorLabel"
                bbg.Adornee = target
                bbg.Size = UDim2.new(0, 250, 0, 40)
                bbg.StudsOffset = Vector3.new(0, 3, 0)
                bbg.AlwaysOnTop = true
                bbg.Parent = guiParent
                local lbl = Instance.new("TextLabel", bbg)
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                lbl.BackgroundTransparency = 0.4
                lbl.TextColor3 = Color3.fromRGB(0, 255, 200)
                lbl.Font = Enum.Font.GothamSemibold
                lbl.TextSize = 12
                lbl.TextWrapped = true
                lbl.Text = name .. " [" .. class .. "]" .. toolName .. modelName
                Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 6)
                task.delay(4, function() pcall(function() bbg:Destroy() end) end)
            end)
        else
            SendNotify("🔍 Nothing under cursor")
        end
    end
end)
