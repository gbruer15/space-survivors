import pygame, random, sys
from pygame.locals import *
pygame.mixer.pre_init(44100, -16, 2, 2048)
pygame.init()
mainClock = pygame.time.Clock()
#from time import clock, time

highscore = 0
score = 0
FPS = 40
fullscreen = False
levelselect = False
upgradesavailabletextblue = 0
upgradesavailabletextgreen = 0
upgradesavailabletextred = 255
addred = False
addblue = False
addgreen = True
minusred = False
minusblue = False
minusgreen = False
winningkillsred = 255
winningkillsblue = 255
titlepage = True
tutorial = False
levelselect = False
game = False
last_fps = FPS
movementchange = 1
enemymissilesoundeffectcountdown = 0

missilesoundeffect = pygame.mixer.Sound('my missile2.wav')
enemykilledsoundeffect = pygame.mixer.Sound('ship explosion.wav')
enemymissilesoundeffect = pygame.mixer.Sound('Galaga2.wav')
winningnoises = pygame.mixer.Sound("winning noises.wav")
winningnoisesplayed = False
bossdyingnoises = pygame.mixer.Sound('boss dying noises.wav')
bossenemyshootsoundeffect = pygame.mixer.Sound('boss enemy shoot.wav')
newgame = True
WINDOWWIDTH = 800 
WINDOWHEIGHT = 600

GAMEWIDTH = WINDOWWIDTH-200
GAMEHEIGHT = WINDOWHEIGHT    

SIDEPANELWIDTH = 200
SIDEPANELHEIGHT = WINDOWHEIGHT

TEXTCOLOR = (255, 255, 255)
windowSurface = pygame.display.set_mode((WINDOWWIDTH, WINDOWHEIGHT), 0, 32)


SIDEPANELRECT = pygame.Rect(GAMEWIDTH, 0, SIDEPANELWIDTH, SIDEPANELHEIGHT)

WINNINGRECTMOVESLOWDOWN = 10
winningRectmoveslowdown = WINNINGRECTMOVESLOWDOWN


BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
RED = (255, 0, 0)
GREEN = (0, 255, 0)
BLUE = (0, 0, 255)

pygame.init()
mainClock = pygame.time.Clock()
pygame.display.set_caption('Game')
pygame.mouse.set_visible(True)
WINDOWCOLOR = (0,0,0)

newgamebutton = pygame.Rect(WINDOWWIDTH/2, WINDOWHEIGHT/2, 200, 50)
newgamebutton.centerx = WINDOWWIDTH/2
newgamebutton.centery = WINDOWHEIGHT/2

continuebutton = pygame.Rect(0, newgamebutton.bottom+25,180, 50)
continuebutton.centerx = WINDOWWIDTH/2
continuebutton.centery = newgamebutton.centery + 60


#Fonts
scoreFont = pygame.font.SysFont(None, 24)
giantFont = pygame.font.SysFont(None, 110)
basicFont = pygame.font.SysFont(None, 48)
smallFont = pygame.font.SysFont(None, 20)
moneyFont = pygame.font.SysFont(None, 30)
upgradedescriptionfontsize = 20
upgradedescriptionFont = pygame.font.SysFont(None, upgradedescriptionfontsize)

SLOWMOTION = 1

def setuptext(text, textcolor,textfont):
        textdrawing = textfont.render(str(text), True, textcolor)
        return textdrawing

leveltext = setuptext("Level 1", (255,255,255), basicFont)
levelRect = pygame.Rect(0, 0, leveltext.get_rect().width, 50)
levelRect.centerx = SIDEPANELRECT.centerx

scoreRect = pygame.Rect(SIDEPANELRECT.left+5, levelRect.bottom, SIDEPANELWIDTH, 50)
highscoreRect = pygame.Rect(SIDEPANELRECT.left+5, scoreRect.bottom, SIDEPANELWIDTH, 50)
cashRect = pygame.Rect(SIDEPANELRECT.left+5, SIDEPANELRECT.top + highscoreRect.bottom, SIDEPANELWIDTH, 50)
livesRect = pygame.Rect(SIDEPANELRECT.left+5, SIDEPANELRECT.top + cashRect.bottom, SIDEPANELWIDTH, 50)
killsRect = pygame.Rect(SIDEPANELRECT.left+5, SIDEPANELRECT.top + livesRect.bottom, SIDEPANELWIDTH, 50)

pausetextRect = pygame.Rect(GAMEWIDTH,cashRect.bottom, SIDEPANELWIDTH, 50)
pausebuttontext = setuptext('Pause', WHITE, basicFont)
pausetextRect.width = pausebuttontext.get_rect().width
pausetextRect.height = pausebuttontext.get_rect().height
pausetextRect.centerx = GAMEWIDTH + (SIDEPANELWIDTH/2)
pausetextRect.bottom = WINDOWHEIGHT - 15

pausebutton = pygame.Rect(0,0,1,1)
pausebutton.width = pausetextRect.width+20
pausebutton.height = pausetextRect.height+6
pausebutton.center = pausetextRect.center

quitlevelRect = pygame.Rect(0,0,1,1)
quitleveltext = setuptext('Quit', WHITE, basicFont)
quitlevelRect.width = quitleveltext.get_rect().width
quitlevelRect.height = quitleveltext.get_rect().height
quitlevelRect.centerx = pausetextRect.centerx
quitlevelRect.bottom = pausetextRect.top - 15

quitlevelbutton = pygame.Rect(0,0,1,1)
quitlevelbutton.width = quitlevelRect.width+22
quitlevelbutton.height = quitlevelRect.height +8
quitlevelbutton.center = quitlevelRect.center

UPGRADEDESCRIPTIONRect = pygame.Rect(GAMEWIDTH, pausetextRect.top - 100, 5, 200)

pausedtextRect = pygame.Rect(0,0, 0, 0)
pausedbuttontext = setuptext('Paused', (0,0,0), basicFont)
pausedtextRect.width = pausedbuttontext.get_rect().width
pausedtextRect.height = pausedbuttontext.get_rect().height
pausedtextRect.centerx = SIDEPANELRECT.centerx
pausedtextRect.bottom = WINDOWHEIGHT - 15

pausedbutton = pygame.Rect(0,0,0,0)
pausedbutton.height = pausedtextRect.height+5
pausedbutton.width = pausedtextRect.width+20
pausedbutton.center = pausedtextRect.center

upgradetitletext = setuptext('Upgrades', (255,255,255), scoreFont)
upgradetitleRect = pygame.Rect(SIDEPANELRECT.left+5, killsRect.bottom, upgradetitletext.get_rect().width, upgradetitletext.get_rect().height)
fpsdisplayRect = pygame.Rect(SIDEPANELRECT.left+5, upgradetitleRect.bottom, 40, 20)














        

def drawmissiles():
    if bool(missiley):
        i = 0
        while i <= len(missiley)-1:
             missile = pygame.Rect(missilex[i]-.5*MISSILEWIDTH, missiley[i]-MISSILELENGTH, MISSILEWIDTH, MISSILELENGTH)
             pygame.draw.rect(windowSurface, MISSILECOLOR, missile)

             if not pause:
                 missiley[i] -= MISSILESPEED
             i += 1



    if bool(missiletoplefty) or bool(missiletoprighty):
        tl = 0
        tr = 0
        while tl <= len(missiletoplefty)-1 or tr <= len(missiletoprighty)-1:
            
            if tl <= len(missiletoplefty)-1:
                 missiletl = pygame.Rect(missiletopleftx[tl]-.5*MISSILEWIDTH, missiletoplefty[tl]-MISSILELENGTH, MISSILEWIDTH, MISSILELENGTH)
                 pygame.draw.rect(windowSurface, MISSILECOLOR, missiletl)
                 if not pause:
                     missiletoplefty[tl] -= MISSILESPEED
                 
            
            if tr <= len(missiletoprighty)-1:
                 missiletr = pygame.Rect(missiletoprightx[tr]-.5*MISSILEWIDTH, missiletoprighty[tr]-MISSILELENGTH, MISSILEWIDTH, MISSILELENGTH)
                 pygame.draw.rect(windowSurface, MISSILECOLOR, missiletr)
                 if not pause:
                     missiletoprighty[tr] -= MISSILESPEED
                 
            tr += 1
            tl += 1

    if bool(missilelefty) or bool(missilerighty) or bool(missilecentery):
        i = 0
        r = 0
        l = 0
        while i <= len(missilecentery)-1 or l <= len(missilelefty)-1 or r <= len(missilerighty)-1:
            
            if i <= len(missilecentery) - 1:
                 missile = pygame.Rect(missilecenterx[i]-.5*MISSILEWIDTH, missilecentery[i]-MISSILELENGTH, MISSILEWIDTH, MISSILELENGTH)
                 pygame.draw.rect(windowSurface, MISSILECOLOR, missile)

                 if not pause:
                     missilecentery[i] -= MISSILESPEED
                                    
            if l <= len(missilelefty) - 1:

                 missilelengthdivisor = (((600*.5)**2+(600-100)**2)**.5)*MISSILELENGTH
                 x = ((((MISSILELENGTH **2)/((((600-100)/(.5*600))**2) + 1))**.5))+(600-100)/missilelengthdivisor
                 pygame.draw.line(windowSurface, MISSILECOLOR, (missileleftx[l], missilelefty[l]), (missileleftx[l]-x, missilelefty[l] - ((600-100)/(.5*600))*x), MISSILEWIDTH)

                 if not pause and MISSILESPEED != 0:
                     missilelengthdivisor = (((600*.5)**2+(600-100)**2)**.5)*MISSILESPEED
                     x = ((((MISSILESPEED **2)/((((600-100)/(.5*600))**2) + 1))**.5))+(600-100)/missilelengthdivisor
                     missileleftx[l] -= x
                     missilelefty[l] -= (((600-100)/(.5*600))*x)             
            

                
            if r <= len(missilerighty) - 1:
                
                 missilelengthdivisor = (((600*.5)**2+(600-100)**2)**.5)*MISSILELENGTH
                 x = ((((MISSILELENGTH **2)/((((600-100)/(.5*600))**2) + 1))**.5))+ (600-100)/missilelengthdivisor
                 pygame.draw.line(windowSurface, MISSILECOLOR, (missilerightx[r], missilerighty[r]), (missilerightx[r]+x, missilerighty[r] - ((600-100)/(.5*600))*x), MISSILEWIDTH)

                 if not pause and MISSILESPEED != 0:
                     missilelengthdivisor = (((600*.5)**2+(600-100)**2)**.5)*MISSILESPEED
                     x = ((((MISSILESPEED **2)/((((600-100)/(.5*600))**2) + 1))**.5))+(600-100)/missilelengthdivisor
                     missilerightx[r] += x
                     missilerighty[r] -= (((600-100)/(.5*600))*x)
            i+=1
            l += 1
            r +=1
#5.9537
      #  * 1.75

while True :
        # set up pygame, the window, and the mouse cursor
    if newgame:
        gototitlepage = False
        gotolevelselect = False
        alreadydisplayedincenter = False
        cash = 0
        cashflow = False
        score = 0
        level = 0
        wonlevel = False

        ENEMYSPAWNRATE = int(FPS/2)
        enemyspawnrate = int(FPS*2)
        
        MAXENEMYSIZE = 70 #70
        MINENEMYSIZE = 20
        ENEMYHEALTH = 1
        MAXENEMYSPEED = 3 
        MINENEMYSPEED = 1
        ENEMYSPEEDDIVIDE = FPS/40
        ENEMYCASH = 10
        ENEMIESKILLED = 20
        enemieskilled = 0
        ENEMYSPAWNRATESLOWDOWN = 15
        enemyspawnrateslowdown = 5
        ENEMYDODGESPEED = 3
        ENEMYSPAWNPOINT = 0
        
        ENEMYCOLOR = (139,69,19)

        ENEMYMISSILESLOWDOWN = FPS*2
        ENEMYMISSILEMOTIONSENSOR = -40
        ENEMYMISSILESPEED = 200/FPS
        ENEMYMISSILEWIDTH = 5
        ENEMYMISSILELENGTH = 15
        ENEMYMISSILECOLOR = (255,255,100)#(254, 35,40)
        
        
         # 15
        MISSILESPEED = 320/FPS
        MISSILEWIDTH = 5
        missilenumber = 0
        MISSILELENGTH = 20
        MISSILESLOWDOWN = FPS/2
        missileslow = 0
        MISSILECOLOR = (150,50,170)#(211,248,3)
        MISSILEATTACK = 1
        MISSILEPIERCE = 1

        doublemissilefire = False
        trimissile = False
        enemymissilefire = False

        upgradedescription = ''
        missileupgradecost = 5000
        missileattackupgradecost = 1000
        missilepierceupgradecost = 3000
        missilespeedupgradecost = 5000
        missilerateupgradecost = 1000
        missilewidthupgradecost = 3000
        playersizeupgradecost = 1500

        MAXMISSILESLOWDOWN = 2
        MAXMISSILEWIDTH = 15
        MAXMISSILELENGTH = 22.5
        MAXPLAYERWIDTH = 12
        MAXMISSILEPIERCE = 10
        MAXMISSILESPEED = 12
        winning = False
        winningkills = 0
        red = 255
        green = 0
        blue = 127
        won = False
        redbottom = 5
        greenbottom = 15
        bluebottom = 3
        eulogy = 0
        CASHFLOW = 6


    enemyx = []
    enemyy = []
    enemyhealth = []
    enemywidth = []
    enemyheight = []
    enemyspeed = []
    enemydodgelist = []

    enemymissilex = []
    enemymissiley = []
    enemymissileslowdown = []

    lootlist = []
    lootcenterx = []
    lootcentery = []
    lootcooldown = []
    LOOTCOOLDOWN = 40

    MONEYLOST = 50
    losscentery = []
    losscenterx = []
    losscooldown = []
    LOSSCOOLDOWN = 30

    MAXSTARS = 800
    MINSTARSPEED = int(40/FPS)
    MAXSTARSPEED = int(800/FPS)
    starx = []
    stary = []
    starspeed = []


    PLAYERWIDTH = 29
    PLAYERHEIGHT = 50

    playerImage = pygame.image.load('spaceship.png')
    jacobsimage = False
    playerRect = playerImage.get_rect()

    player = pygame.Rect(300, 300, (PLAYERWIDTH)*(131/171), (PLAYERHEIGHT)*(280/299))
    playerRect.centerx = player.centerx
    player.top = playerRect.top

    enemyImage = pygame.image.load('enemyspaceship.png')

    missilex = []
    missiley = []
    missilepierce = []

    missilecentery = []
    missilecenterx = []
    missilecenterpierce = []
    missileleftx = []
    missilelefty = []
    missilerighty = []
    missilerightx = []
    missilerightpierce =[]
    missileleftpierce = []
    
    
    missiletoplefty = []
    missiletopleftx = []
    missiletopleftpierce = []
    
    missiletoprighty = []
    missiletoprightx = []
    missiletoprightpierce = [] 
    

    #Title

    titlestarx = []
    titlestary = []
    titlestarxspeed = []
    titlestaryspeed = []
    MAXTITLESTARSPEED = 2
    titlestarmoveslowdown = 0
    TITLESTARMOVESLOWDOWN = 1
        
        
       

    largeFont = pygame.font.SysFont(None, 140)


    
    titleRect = pygame.Rect(25, 25, 400,400)
    title = setuptext('Space Survivor', WHITE, largeFont)

    NEWGAMEBUTTONCOLOR = (255,0,255)
    CONTINUEBUTTONCOLOR = (255,0,255)
    tutbuttoncolor = (255,0,255)

    tutorialbuttontext = setuptext('How to Play', WHITE, basicFont)
    tutorialbuttonRect = tutorialbuttontext.get_rect()
    tutorialactualbutton = tutorialbuttontext.get_rect()
    tutorialbuttonstring = 'How to Play'
    tutorialbuttonwidth = 210
    howtoplaystring = ''

    tutorial = False
    shootstars = True
    attractstars = False
    repelstars = False
    deletestars = False
    bouncingstars = False
    pause = False
    crazy = True
    slowmotion = 1
    centermouse = False
    displaybuttons = True
    vertical = False
    horizontal = False
    MOUSEMOVESLOWDOWN = 5
    mousemoveslowdown = MOUSEMOVESLOWDOWN
    STARRATE = 20
    radius = 10
    width = 2
    displaycircle = False
    randomspeed = True
    cleardisplay= True
    asfastaspossible = False
    quarter1 = False
    quarter2 = False
    quarter3 = False
    quarter4 = False

    SPAWNSTARRATE = 0
    spawnstarrate = SPAWNSTARRATE


    
    while titlepage:
        if centermouse:
            pygame.mouse.set_pos(WINDOWWIDTH/2, WINDOWHEIGHT/2)
        elif horizontal and vertical:
            pygame.mouse.set_pos(horizontalline, verticalline)
        elif horizontal:
            mousemoveslowdown -= 1
            if mousemoveslowdown <= 0:
                mousemoveslowdown = MOUSEMOVESLOWDOWN
                pygame.mouse.set_pos(pygame.mouse.get_pos()[0], verticalline)
        elif vertical:
            mousemoveslowdown -= 1
            if mousemoveslowdown <= 0:
                mousemoveslowdown = MOUSEMOVESLOWDOWN
                pygame.mouse.set_pos(horizontalline, pygame.mouse.get_pos()[1])
        elif quarter1:
            pygame.mouse.set_pos(WINDOWWIDTH/4, WINDOWHEIGHT/4)
        elif quarter2:
            pygame.mouse.set_pos(3*WINDOWWIDTH/4, WINDOWHEIGHT/4)
        elif quarter3:
            pygame.mouse.set_pos(3*WINDOWWIDTH/4, 3*WINDOWHEIGHT/4)
        elif quarter4:
            pygame.mouse.set_pos(WINDOWWIDTH/4, 3*WINDOWHEIGHT/4)
        if cleardisplay:
            windowSurface.fill((0,0,0)) #(0,200,87)

        pixArray = pygame.PixelArray(windowSurface)

        spawnstarrate -= 1
        if shootstars and not deletestars and spawnstarrate <= 0:
            spawnstarrate = SPAWNSTARRATE
            i = 0
            while i <= STARRATE/slowmotion:
                if randomspeed:
                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(random.randint(-MAXTITLESTARSPEED, MAXTITLESTARSPEED)+random.randint(-1,1))
                    titlestaryspeed.append(random.randint(-MAXTITLESTARSPEED, MAXTITLESTARSPEED)+random.randint(-1,1))
                else:
                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED-1)
                    titlestaryspeed.append(-MAXTITLESTARSPEED-1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED-1)
                    titlestaryspeed.append(-MAXTITLESTARSPEED)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED-1)
                    titlestaryspeed.append(-MAXTITLESTARSPEED+1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED-1)
                    titlestaryspeed.append(0)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED-1)
                    titlestaryspeed.append(MAXTITLESTARSPEED-1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED-1)
                    titlestaryspeed.append(MAXTITLESTARSPEED)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED-1)
                    titlestaryspeed.append(MAXTITLESTARSPEED+1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED)
                    titlestaryspeed.append(-MAXTITLESTARSPEED-1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED)
                    titlestaryspeed.append(-MAXTITLESTARSPEED)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED)
                    titlestaryspeed.append(-MAXTITLESTARSPEED+1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED)
                    titlestaryspeed.append(0)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED)
                    titlestaryspeed.append(MAXTITLESTARSPEED-1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED)
                    titlestaryspeed.append(MAXTITLESTARSPEED)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED)
                    titlestaryspeed.append(MAXTITLESTARSPEED+1)


                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED+1)
                    titlestaryspeed.append(-MAXTITLESTARSPEED-1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED+1)
                    titlestaryspeed.append(-MAXTITLESTARSPEED)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED+1)
                    titlestaryspeed.append(-MAXTITLESTARSPEED+1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED+1)
                    titlestaryspeed.append(0)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED+1)
                    titlestaryspeed.append(MAXTITLESTARSPEED-1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED+1)
                    titlestaryspeed.append(MAXTITLESTARSPEED)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(-MAXTITLESTARSPEED+1)
                    titlestaryspeed.append(MAXTITLESTARSPEED+1)


                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(0)
                    titlestaryspeed.append(-MAXTITLESTARSPEED-1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(0)
                    titlestaryspeed.append(-MAXTITLESTARSPEED)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(0)
                    titlestaryspeed.append(-MAXTITLESTARSPEED+1)


                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(0)
                    titlestaryspeed.append(MAXTITLESTARSPEED-1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(0)
                    titlestaryspeed.append(MAXTITLESTARSPEED)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(0)
                    titlestaryspeed.append(MAXTITLESTARSPEED+1)





                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED-1)
                    titlestaryspeed.append(-MAXTITLESTARSPEED-1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED-1)
                    titlestaryspeed.append(-MAXTITLESTARSPEED)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED-1)
                    titlestaryspeed.append(-MAXTITLESTARSPEED+1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED-1)
                    titlestaryspeed.append(0)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED-1)
                    titlestaryspeed.append(MAXTITLESTARSPEED-1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED-1)
                    titlestaryspeed.append(MAXTITLESTARSPEED)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED-1)
                    titlestaryspeed.append(MAXTITLESTARSPEED+1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED)
                    titlestaryspeed.append(-MAXTITLESTARSPEED-1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED)
                    titlestaryspeed.append(-MAXTITLESTARSPEED)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED)
                    titlestaryspeed.append(-MAXTITLESTARSPEED+1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED)
                    titlestaryspeed.append(0)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED)
                    titlestaryspeed.append(MAXTITLESTARSPEED-1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED)
                    titlestaryspeed.append(MAXTITLESTARSPEED)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED)
                    titlestaryspeed.append(MAXTITLESTARSPEED+1)


                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED+1)
                    titlestaryspeed.append(-MAXTITLESTARSPEED-1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED+1)
                    titlestaryspeed.append(-MAXTITLESTARSPEED)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED+1)
                    titlestaryspeed.append(-MAXTITLESTARSPEED+1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED+1)
                    titlestaryspeed.append(0)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED+1)
                    titlestaryspeed.append(MAXTITLESTARSPEED-1)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED+1)
                    titlestaryspeed.append(MAXTITLESTARSPEED)

                    titlestarx.append(pygame.mouse.get_pos()[0])
                    titlestary.append(pygame.mouse.get_pos()[1])
                    titlestarxspeed.append(MAXTITLESTARSPEED+1)
                    titlestaryspeed.append(MAXTITLESTARSPEED+1)
                    i += 200
                    
                i += 1

        if titlestarmoveslowdown >= TITLESTARMOVESLOWDOWN:
            titlestarmoveslowdown = 0
            i=0
            while i <= len(titlestarx)-1:
                stardeleted = False
                if not pause and 0 < ((titlestarx[i]-pygame.mouse.get_pos()[0])**2+(titlestary[i]-pygame.mouse.get_pos()[1])**2)**.5 <  radius and not repelstars and not attractstars and not deletestars and crazy:
                    titlestaryspeed[i] += int(random.randint(-3,3)/slowmotion)
                    titlestarxspeed[i] += int(random.randint(-3,3)/slowmotion)
                
            
                elif repelstars and not pause:
                    if ((titlestarx[i]-pygame.mouse.get_pos()[0])**2+(titlestary[i]-pygame.mouse.get_pos()[1])**2)**.5 <  radius:
                        if titlestarx[i]-pygame.mouse.get_pos()[0] > 0:
                            titlestarxspeed[i] += int((titlestarx[i] - pygame.mouse.get_pos()[0])/8)
                        elif titlestarx[i]-pygame.mouse.get_pos()[0] < 0:
                            titlestarxspeed[i] -= -int((titlestarx[i] - pygame.mouse.get_pos()[0])/8)

                        if titlestary[i]-pygame.mouse.get_pos()[1] > 0:
                            titlestaryspeed[i] += int((titlestary[i] - pygame.mouse.get_pos()[1])/8)
                        elif titlestary[i]-pygame.mouse.get_pos()[1] < 0:
                            titlestaryspeed[i] -= -int((titlestary[i] - pygame.mouse.get_pos()[1])/8)
                            
                        if titlestaryspeed[i] > MAXTITLESTARSPEED:
                            titlestaryspeed[i] = titlestaryspeed[i] - random.randint(0,4)
                        if titlestaryspeed[i] < -1 * MAXTITLESTARSPEED:
                            titlestaryspeed[i] = titlestaryspeed[i] + random.randint(0,4)

                        if titlestarxspeed[i] > MAXTITLESTARSPEED:
                            titlestarxspeed[i] = titlestarxspeed[i] - random.randint(0,4)
                        if titlestarxspeed[i] < -1 * MAXTITLESTARSPEED:
                            titlestarxspeed[i] = titlestarxspeed[i] + random.randint(0,4)
                elif attractstars and not pause:
                    if ((titlestarx[i]-pygame.mouse.get_pos()[0])**2+(titlestary[i]-pygame.mouse.get_pos()[1])**2)**.5 <  radius:
                        if titlestarx[i]-pygame.mouse.get_pos()[0] < 0:
                            titlestarx[i] += int((-int((titlestarx[i] - pygame.mouse.get_pos()[0])*.2)-random.randint(-10,10))/slowmotion)
                        elif titlestarx[i]-pygame.mouse.get_pos()[0] > 0:
                            titlestarx[i] -= int((int((titlestarx[i] - pygame.mouse.get_pos()[0])*.2)+random.randint(-10,10))/slowmotion)

                        if titlestary[i]-pygame.mouse.get_pos()[1] < 0:
                            titlestary[i] += int((-int((titlestary[i] - pygame.mouse.get_pos()[1])*.2)-random.randint(-10,10))/slowmotion)
                        elif titlestary[i]-pygame.mouse.get_pos()[1] > 0:
                            titlestary[i] -= int((int((titlestary[i] - pygame.mouse.get_pos()[1])*.2)+random.randint(-10,10))/slowmotion)

                        if False:
                            if titlestaryspeed[i] > 10:
                                titlestaryspeed[i] = 10
                            if titlestaryspeed[i] < -10:
                                titlestaryspeed[i] = 10

                            if titlestarxspeed[i] > 10:
                                titlestarxspeed[i] = 10
                            if titlestarxspeed[i] < -10:
                                titlestarxspeed[i] = 10
                elif deletestars:
                    if ((titlestarx[i]-pygame.mouse.get_pos()[0])**2+(titlestary[i]-pygame.mouse.get_pos()[1])**2)**.5 <  radius:
                        del titlestarx[i]
                        del titlestary[i]
                        del titlestaryspeed[i]
                        del titlestarxspeed[i]
                        stardeleted = True
                        i -= 1
                if not stardeleted and not pause:
                    if ((titlestarx[i]-pygame.mouse.get_pos()[0])**2+(titlestary[i]-pygame.mouse.get_pos()[1])**2)**.5 >  radius and attractstars or not attractstars:
                        titlestarx[i] += int(titlestarxspeed[i]/slowmotion)
                        titlestary[i] += int(titlestaryspeed[i]/slowmotion)
                i += 1
                
        else:
            titlestarmoveslowdown += 1
            
        i = 0
        while i <= len(titlestarx)- 1:
            if 0 < titlestary[i] < WINDOWHEIGHT and 0 < titlestarx[i] < WINDOWWIDTH:
                pixArray[titlestarx[i]][titlestary[i]] = (255,255,255)
            elif bouncingstars:
                if titlestary[i] > WINDOWHEIGHT or titlestary[i] < 0:
                    titlestaryspeed[i] = -titlestaryspeed[i]
                    while titlestary[i] < 0 or titlestary[i] > WINDOWHEIGHT:
                            titlestary[i] += titlestaryspeed[i]
                if titlestarx[i] < 0 or titlestarx[i] > WINDOWWIDTH:
                    titlestarxspeed[i] = -titlestarxspeed[i]
                    while titlestarx[i] < 0 or titlestarx[i] > WINDOWWIDTH:
                        titlestarx[i] += titlestarxspeed[i]
                
            else:
                del titlestary[i]
                del titlestarx[i]
                del titlestarxspeed[i]
                del titlestaryspeed[i]
                i -=1
                
            i += 1
        del pixArray
            
                

        if newgame:
            CONTINUEBUTTONCOLOR = (187,187,187)
            #######resetall()#########
       # Check For Input
        for event in pygame.event.get():
            if event.type == QUIT:
                pygame.quit()
                sys.exit()
            if event.type == MOUSEBUTTONDOWN:
                if shootstars:
                    shootstars = False
                else:
                    shootstars = True
                mousex = event.pos[0]
                mousey = event.pos[1]
                if displaybuttons:
                    if newgamebutton.collidepoint(mousex, mousey):
                        titlepage = False
                        newgame = True
                        levelselect = True
                    if not newgame:
                        if continuebutton.collidepoint(event.pos):
                            newgame = False
                            titlepage = False
                            levelselect = True
                    if tutorialactualbutton.collidepoint(event.pos[0], event.pos[1]):
                        if tutorial:
                            tutorial = False
                            tutorialbuttonstring = 'How to Play'
                            howtoplaystring = 'Ignore enemies, be satisfied, die.'
                            tutorialbuttonwidth = 210
                        else:
                            tutorial = True
                            tutorialbuttonstring = 'How not to Play'
                            tutorialbuttonwidth = 280
                            howtoplaystring = 'Shoot enemies, upgrade yourself, don\'t die.'
            if event.type == MOUSEBUTTONUP:
                if shootstars:
                    shootstars = False
                else:
                    shootstars = True
            if event.type == MOUSEMOTION:
                if newgamebutton.collidepoint(event.pos[0], event.pos[1]):
                    NEWGAMEBUTTONCOLOR = (255,150,255)
                else:
                    NEWGAMEBUTTONCOLOR = (255,0,255)

                if not newgame:
                    if continuebutton.collidepoint(event.pos):
                        CONTINUEBUTTONCOLOR = (255,150,255)
                    else:
                        CONTINUEBUTTONCOLOR = (255,0,255)
                    
                if tutorialactualbutton.collidepoint(event.pos[0], event.pos[1]):
                    tutbuttoncolor =  (255,150, 255)
                else:
                    tutbuttoncolor = (255,0,255)
            if event.type == KEYDOWN:
                if event.key == K_ESCAPE:
                    pygame.quit()
                    sys.exit()
                elif event.key == ord("i"):
                    cleardisplay = not cleardisplay
                elif event.key == ord("u"):
                    asfastaspossible = not asfastaspossible
                elif event.key == ord('j'):
                    if randomspeed:
                        randomspeed = False
                        SPAWNSTARRATE = 5
                    else:
                        randomspeed = True
                        SPAWNSTARRATE = 0
                    
                elif event.key == ord('-'):
                    if WINDOWWIDTH == 800:
                        WINDOWWIDTH = 600
                    else:
                        WINDOWWIDTH = 800
                    windowSurface = pygame.display.set_mode((WINDOWWIDTH, WINDOWHEIGHT), 0, 32)
                elif event.key == ord('e'):
                    if radius < 120:
                        radius += 10
                    else:
                        radius = 10
                    print(radius)
                elif event.key == ord('y'):
                    if shootstars:
                        shootstars = False
                    else:
                        shootstars = True
                elif event.key == ord('s'):
                    if slowmotion == 1:
                        slowmotion = 2
                    elif slowmotion == 2:
                        slowmotion = .5
                    elif slowmotion == .5:
                        slowmotion = 1
                    print('Slowmotion: ' + str(slowmotion))
                elif event.key == ord('k'):
                    titlestary = []
                    titlestarx = []
                    titlestarxspeed = []
                    titlestaryspeed = []
                elif event.key == ord('b'):
                    if bouncingstars:
                        bouncingstars = False
                    else:
                        bouncingstars = True
                    print('Bounce: ' + str(bouncingstars))
                elif event.key == ord('p'):
                    if pause:
                        pause = False
                    else:
                        pause = True
                    print('Paused: ' + str(pause))
                elif event.key == ord('d'):
                    attractstars = False
                    repelstars = False
                    if deletestars:
                        deletestars = False
                    else:
                        deletestars = True
                    print('Deleting: ' + str(deletestars))
                elif event.key == ord('r'):
                    attractstars = False
                    deletestars = False
                    if not repelstars:                        
                        repelstars = True
                    else:
                        repelstars = False
                    print('Repelling: ' + str(repelstars))
                elif event.key == ord("a"):
                    repelstars = False
                    deletestars = False
                    if attractstars:
                        attractstars = False
                    else:
                        attractstars = True
                    print('Attracting: ' + str(attractstars))
                elif event.key == ord('c'):
                    if crazy:
                        crazy = False
                    else:
                        crazy= True
                    print('Crazy: ' + str(crazy))
                elif event.key == ord('m'):
                    horizontal = False
                    vertical = False
                    if centermouse:
                        centermouse = False
                        quarter1 = True
                    elif quarter1:
                        quarter1 = False
                        quarter2 = True
                    elif quarter2:
                        quarter2 = False
                        quarter3 = True
                    elif quarter3:
                        quarter3 = False
                        quarter4 = True
                    elif quarter4:
                        quarter4 = False
                    else:
                        centermouse = True
                    print('Centered: ' + str(centermouse))
                elif event.key == ord('q'):
                    if displaybuttons:
                        displaybuttons = False
                    else:
                        displaybuttons = True
                elif event.key == ord('v'):
                    centermouse = False
                    if vertical:
                        vertical = False
                    else:
                        vertical = True
                    horizontalline = pygame.mouse.get_pos()[0]
                elif event.key == ord('h'):
                    centermouse = False
                    if horizontal:
                        horizontal = False
                    else:
                        horizontal = True
                    verticalline = pygame.mouse.get_pos()[1]
                elif event.key == ord('l'):
                    if displaycircle:
                        displaycircle = False
                    else:
                        displaycircle = True
                elif event.key == ord('o'):
                    gettingstarrate = True
                    firstdigit = False
                    seconddigit = False
                    while gettingstarrate:
                        for event in pygame.event.get():
                            if event.type == QUIT:
                                pygame.quit()
                                sys.exit()
                            if event.type == KEYDOWN:
                                if event.key == K_ESCAPE:
                                    pygame.quit()
                                    sys.exit()
                                for i in range(48,58):
                                    if i == event.key:
                                        i -= 48
                                        if not bool(firstdigit):
                                            firstdigit = i+1
                                            print(i)
                                        else:
                                            seconddigit = i
                                            print(i)
                                            pause = True
                                            gettingstarrate = False
                                            STARRATE = int(str(firstdigit-1)+str(seconddigit))
                                            print(STARRATE, firstdigit-1, seconddigit)
                                            
                elif event.key == ord('f'):
                    if not fullscreen:
                        fullscreen = True
                        windowSurface = pygame.display.set_mode((WINDOWWIDTH, WINDOWHEIGHT), pygame.FULLSCREEN)
                    else:
                        fullscreen = False                           
                        windowSurface = pygame.display.set_mode((WINDOWWIDTH, WINDOWHEIGHT), 0, 32)
                    
        
        # Draw Stuff
        newgametext = basicFont.render('New Game', True, WHITE, NEWGAMEBUTTONCOLOR)
        newgameRect = newgametext.get_rect()
        newgameRect.centerx = newgamebutton.centerx
        newgameRect.centery = newgamebutton.centery

        continuetext = basicFont.render('Continue', True, WHITE, CONTINUEBUTTONCOLOR)
        continueRect = continuetext.get_rect()
        continueRect.centerx = continuebutton.centerx
        continueRect.centery = continuebutton.centery

        tutorialbuttontext = setuptext(tutorialbuttonstring, WHITE, basicFont)
        tutorialbuttonRect = tutorialbuttontext.get_rect()
        tutorialactualbutton = tutorialbuttontext.get_rect()

        tutorialactualbutton.height = 50
        tutorialactualbutton.centery = continueRect.centery+60
        tutorialactualbutton.width = tutorialbuttonwidth
        tutorialactualbutton.centerx = WINDOWWIDTH/2


        tutorialbuttonRect.centerx= tutorialactualbutton.centerx
        tutorialbuttonRect.centery = tutorialactualbutton.centery

        if displaybuttons:
            pygame.draw.rect(windowSurface, NEWGAMEBUTTONCOLOR, newgamebutton)
            pygame.draw.rect(windowSurface, CONTINUEBUTTONCOLOR, continuebutton)
            pygame.draw.rect(windowSurface, tutbuttoncolor, tutorialactualbutton)
            
            
            tutorialtext = setuptext(howtoplaystring, WHITE, basicFont)
            tutorialtextRect = tutorialtext.get_rect()
            tutorialtextRect. centerx = WINDOWWIDTH/2
            tutorialtextRect.centery = tutorialactualbutton.centery+60

            windowSurface.blit(tutorialtext, tutorialtextRect)
            windowSurface.blit(continuetext, continueRect)
            
            windowSurface.blit(tutorialbuttontext, tutorialbuttonRect)
            windowSurface.blit(newgametext, newgameRect)
            windowSurface.blit(title,titleRect)
        if displaycircle:
            pygame.draw.circle(windowSurface, (255,0,0), pygame.mouse.get_pos(), radius, width)
        pygame.display.update()
        mainClock.tick(FPS)

    if newgame:
        d= 0
        
    firemissile = True
    newgame = False

    score = 0
    kills = 0
    SCOREDELAY = int(FPS/20)
    scoredelay = 0
    dead = False
    deaths = 0

    returntomenutext = setuptext('Return to Title', WHITE, basicFont)
    returntomenuRect = returntomenutext.get_rect()
    returntomenuRect.centerx = WINDOWWIDTH/2
    returntomenuRect.centery = GAMEWIDTH-150

    returntomenubutton = pygame.Rect(0,0,returntomenuRect.width + 20, returntomenuRect.height+10)
    returntomenubutton.centerx = WINDOWWIDTH/2
    returntomenubutton.centery = returntomenuRect.centery
    returntomenucolor = (50,50,100)

    ###LEVEL SELECT####
    while len(starx)<MAXSTARS:
        starx.append(random.randint(0,1366))
        stary.append(random.randint(0, 768))
        starspeed.append(random.randint(MINSTARSPEED,MAXSTARSPEED))
        
    while levelselect:
        windowSurface.fill(WINDOWCOLOR)
        i = 0
        pixArray = pygame.PixelArray(windowSurface)
        while i <= len(starx)-1:
            stary[i] += starspeed[i]
            if stary[i] < WINDOWHEIGHT and starx[i] < WINDOWWIDTH:
                pixArray[starx[i]][stary[i]] = (255,255,255)
            if stary[i]> 768:
                del stary[i]
                del starx[i]
                del starspeed[i]
                i -= 1
            
            i += 1

        while len(starx)<MAXSTARS:
            starx.append(random.randint(0,1366))
            stary.append(0)
            starspeed.append(random.randint(MINSTARSPEED,MAXSTARSPEED))

        del pixArray

        for event in pygame.event.get():
            if event.type == QUIT:
                pygame.quit()
                sys.exit()

            if event.type == MOUSEMOTION:
                if returntomenubutton.collidepoint(event.pos[0], event.pos[1]):
                    returntomenucolor = (100,100,255)
                else:
                    returntomenucolor = (50,50,100)

            if event.type == MOUSEBUTTONDOWN:
                if returntomenubutton.collidepoint(event.pos):
                    levelselect = False
                    titlepage = True
                if level1button.collidepoint(event.pos):
                    levelselect = False
                    game = True
                    currentlevel = 1
                    lives = 5
                    ENEMYSPAWNRATE = int(FPS/2)
                    enemyspawnrate = int(FPS*2)
                    
                    MAXENEMYSIZE = 70 #70
                    MINENEMYSIZE = 20
                    ENEMYHEALTH = 1
                    MAXENEMYSPEED = 3 
                    MINENEMYSPEED = 1
                    ENEMYSPEEDDIVIDE = FPS/40
                    ENEMYCASH = 10
                    ENEMIESKILLED = 20
                    enemieskilled = 0
                    ENEMYSPAWNRATESLOWDOWN = 15
                    enemyspawnrateslowdown = 5
                    ENEMYDODGESPEED = 3
                    
                    ENEMYCOLOR = (139,69,19)
                    
                    ENEMYMISSILESLOWDOWN = FPS*2
                    ENEMYMISSILEMOTIONSENSOR = -40
                    ENEMYMISSILESPEED = 200/FPS
                    ENEMYMISSILEWIDTH = 5
                    ENEMYMISSILELENGTH = 15
                    ENEMYMISSILECOLOR = (254, 35,40)
                    
                    MISSILESPEED = 320/FPS
                    MISSILEWIDTH = 5
                    missilenumber = 0
                    MISSILELENGTH = 20
                    MISSILESLOWDOWN = FPS/2
                    missileslow = 0
                    MISSILECOLOR = (253,201,7)#(211,248,3)
                    MISSILEATTACK = 1
                    MISSILEPIERCE = 1

                    doublemissilefire = False
                    trimissile = False
                    enemymissilefire = False

                    upgradedescription = ''
                    missileupgradecost = 5000
                    missileattackupgradecost = 1000
                    missilepierceupgradecost = 3000
                    missilespeedupgradecost = 5000
                    missilerateupgradecost = 1000
                    missilewidthupgradecost = 3000
                    playersizeupgradecost = 1500

                if level2button.collidepoint(event.pos):
                    levelselect = False
                    game = True
                    currentlevel = 2
                    lives = 5

                if level3button.collidepoint(event.pos):
                    levelselect = False
                    game = True
                    currentlevel = 3
                    lives = 3

        LEVELSELECTTITLE = setuptext('Level Select', WHITE, giantFont)
        LEVELSELECTTITLERECT = LEVELSELECTTITLE.get_rect()
        LEVELSELECTTITLERECT.centerx = WINDOWWIDTH/2
        LEVELSELECTTITLERECT.top = 10

        level1button = pygame.Rect(0,0,130,110)
        level1button.left = 75
        level1button.top = 125
        pygame.draw.rect(windowSurface, (120,43, 108),level1button)

        level4button = pygame.Rect(0,0,130,110)
        level4button.right = WINDOWWIDTH-75
        level4button.top = 125
        pygame.draw.rect(windowSurface, (120,43, 108),level4button)

        level2button = pygame.Rect(0,0,130,110)
        level2button.left = level1button.right+45
        level2button.top = 125
        pygame.draw.rect(windowSurface, (120,43, 108),level2button)

        level3button = pygame.Rect(0,0,130,110)
        level3button.right = level4button.left-45
        level3button.top = 125
        pygame.draw.rect(windowSurface, (120,43, 108),level3button)

        windowSurface.blit(LEVELSELECTTITLE, LEVELSELECTTITLERECT)

        pygame.draw.rect(windowSurface, returntomenucolor, returntomenubutton)
        windowSurface.blit(returntomenutext, returntomenuRect)

        pygame.display.update()
        mainClock.tick(FPS)      

    
    
    #START GAME
    enemydodge = True
    pausebuttoncolor = (255,30,187)
    quitlevelbuttoncolor = (205,0,0)
    
    while len(starx)<MAXSTARS:
        starx.append(random.randint(0,1366))
        stary.append(random.randint(0, 768))
        starspeed.append(random.randint(MINSTARSPEED,MAXSTARSPEED))
        
    instructions = True
    firstloop = True
    pause = True
    areyousure = False
    bossImage = pygame.image.load('big boss.png')
    bossRect = bossImage.get_rect()
    boss = bossImage.get_rect()
    boss.center = bossRect.center = (GAMEWIDTH/2, -150)
    bossmovingleft = True
    bossmovingdown = True
    bossspeedslowdown = 300
    BOSSSPEEDSLOWDOWN = 10
    MAXBOSSHEALTH = 1000
    BOSSHEALTH = MAXBOSSHEALTH
    bosshorizontalspeed = 0
    bossverticalspeed = 1
    bossenemyspawnrate = 500
    BOSSENEMYSPAWNRATE = 75
    BOSSMISSILEFIRERATE = 21
    bossmissilefirerate = 400
    
    while game:

        while areyousure:                   
                
            areyousuretextline1 = setuptext('Are you sure you', WHITE, basicFont)
            areyousuretextline2 = setuptext('want to quit?', WHITE, basicFont)

            areyousureRectline1 = areyousuretextline1.get_rect()
            areyousureRectline1.center = (GAMEWIDTH/2, GAMEHEIGHT/3)

            areyousureRectline2 = areyousuretextline2.get_rect()
            areyousureRectline2.centerx = GAMEWIDTH/2
            areyousureRectline2.top = areyousureRectline1.bottom +5

            if gototitlepage or gotolevelselect:
                areyousureRectline1.top = gameoverRect.bottom
                areyousureRectline2.top = areyousureRectline1.bottom+5
                areyousureRectline1.centerx = areyousureRectline2.centerx = WINDOWWIDTH/2

            pygame.draw.rect(windowSurface, (0,0,0), areyousureRectline1)
            pygame.draw.rect(windowSurface, (0,0,0), areyousureRectline2)

            windowSurface.blit(areyousuretextline1, areyousureRectline1)
            windowSurface.blit(areyousuretextline2, areyousureRectline2)

            if gototitlepage or gotolevelselect:
                iamsuretext = setuptext('Of course!', WHITE, basicFont)
                iamsuretextRect = iamsuretext.get_rect()
                iamsuretextRect.right = WINDOWWIDTH/2-25
                iamsuretextRect.top = areyousureRectline2.bottom + 25
                

                iamnotsuretext = setuptext('No way!!', WHITE, basicFont)
                iamnotsuretextRect = iamnotsuretext.get_rect()
                iamnotsuretextRect.left = WINDOWWIDTH/2+25
                iamnotsuretextRect.top = areyousureRectline2.bottom + 25

                iamsurebutton = pygame.Rect(0,0,1,1)
                iamsurebutton.width = iamsuretextRect.width + 20
                iamsurebutton.height = iamsuretextRect.height + 10
                iamsurebutton.center = iamsuretextRect.center

                iamnotsurebutton = pygame.Rect(0,0,1,1)
                iamnotsurebutton.width = iamnotsuretextRect.width + 20
                iamnotsurebutton.height = iamnotsuretextRect.height + 10
                iamnotsurebutton.center = iamnotsuretextRect.center

            else:
                iamsuretext = setuptext('Of course!', WHITE, basicFont)
                iamsuretextRect = iamsuretext.get_rect()
                iamsuretextRect.right = GAMEWIDTH/2-25
                iamsuretextRect.top = areyousureRectline2.bottom + 25
                

                iamnotsuretext = setuptext('No way!!', WHITE, basicFont)
                iamnotsuretextRect = iamnotsuretext.get_rect()
                iamnotsuretextRect.left = GAMEWIDTH/2+25
                iamnotsuretextRect.top = areyousureRectline2.bottom + 25

                iamsurebutton = pygame.Rect(0,0,1,1)
                iamsurebutton.width = iamsuretextRect.width + 20
                iamsurebutton.height = iamsuretextRect.height + 10
                iamsurebutton.center = iamsuretextRect.center

                iamnotsurebutton = pygame.Rect(0,0,1,1)
                iamnotsurebutton.width = iamnotsuretextRect.width + 20
                iamnotsurebutton.height = iamnotsuretextRect.height + 10
                iamnotsurebutton.center = iamnotsuretextRect.center

            if iamnotsurebutton.collidepoint(pygame.mouse.get_pos()):
                iamnotsurecolor = (255,55,55)
            else:
                iamnotsurecolor = (200,0,0)

            if iamsurebutton.collidepoint(pygame.mouse.get_pos()):
                iamsurecolor = (55,225,55)
            else:
                iamsurecolor = (0,170,0)
            

            pygame.draw.rect(windowSurface, iamsurecolor, iamsurebutton)
            pygame.draw.rect(windowSurface, iamnotsurecolor, iamnotsurebutton)

            windowSurface.blit(iamsuretext, iamsuretextRect)
            windowSurface.blit(iamnotsuretext, iamnotsuretextRect)

            for event in pygame.event.get():
                if event.type == QUIT:
                    pygame.quit()
                    sys.exit()
                if event.type == MOUSEBUTTONDOWN:
                    if event.button == 1:
                        if iamsurebutton.collidepoint(event.pos):
                            if gototitlepage:
                                areyousure = False
                                game = False
                                titlepage = True
                                dead = T = False
                                gototitlepage = False
                            elif gotolevelselect:
                                areyousure = False
                                game = False
                                levelselect = True
                                dead = T = False
                                gotolevelselect = False
                            else:
                                areyousure = False
                                pause = False
                                game = False
                                levelselect = True
                            

                        elif iamnotsurebutton.collidepoint(event.pos):
                            if gototitlepage or gotolevelselect:
                                areyousure = False
                                dead = T = True
                                gototitlepage = gotolevelselect = False
                            else:
                                areyousure = False
                                pause = True
                

            pygame.display.update()

            mainClock.tick(FPS)

        if not dead:
            player.width = PLAYERWIDTH*(131/171)
            player.height = PLAYERHEIGHT*(280/299)

            
            #(50,50,187)
            windowSurface.fill(WINDOWCOLOR)

            i = 0
            pixArray = pygame.PixelArray(windowSurface)
            while i <= len(starx)-1:
                stary[i] += starspeed[i]
                if stary[i] < WINDOWHEIGHT and starx[i] < WINDOWWIDTH:
                    pixArray[starx[i]][stary[i]] = (255,255,255)
                if stary[i]> 768:
                    del stary[i]
                    del starx[i]
                    del starspeed[i]
                    i -= 1
                
                
                
                i += 1

            while len(starx)<MAXSTARS:
                starx.append(random.randint(0,1366))
                stary.append(0)
                starspeed.append(random.randint(MINSTARSPEED,MAXSTARSPEED))

            del pixArray

            
                


            
            if pygame.mouse.get_pressed()[0]:
                firemissile = True
            else:
                firemissile = False
           

            

            if currentlevel == 2 and not won and not winning:
                enemymissilefire = True
                ENEMYMISSILESLOWDOWN = FPS/2
                ENEMYMISSILEMOTIONSENSOR = 800
                bosshit = False
                if player.colliderect(boss):
                    dead = True
                    bosshit = True
                bossRect = bossImage.get_rect()
                bossRect.center = boss.center
                windowSurface.blit(bossImage, bossRect)
                if bossspeedslowdown <=0:
                    bossspeedslowdown = BOSSSPEEDSLOWDOWN/movementchange
                    bosshorizontalspeed = random.randint(1,MAXBOSSSPEED)
                    bossverticalspeed = random.randint(1,MAXBOSSSPEED)
                bossspeedslowdown -= 1
                if boss.top <= 175 and bossmovingdown:
                    boss.top += bossverticalspeed*movementchange
                else:
                    bossmovingdown = False
                    if boss.top >= -30:
                        boss.top -= bossverticalspeed*movementchange
                    else:
                        bossmovingdown = True
                if boss.left >= -50 and bossmovingleft:
                    boss.left -= bosshorizontalspeed*movementchange
                else:
                    bossmovingleft = False
                    if boss.right <= GAMEWIDTH+50 and not bossmovingleft:
                        boss.right += bosshorizontalspeed*movementchange
                    else:
                        bossmovingleft = True
                bossenemyspawnrate -= 1
                if bossenemyspawnrate <= 0:
                    bossenemyspawnrate = BOSSENEMYSPAWNRATE/movementchange
                    enemyx.append(boss.left+boss.width/5)
                    enemyx.append(boss.left+(boss.width/5)*2)
                    enemyx.append(boss.left+(boss.width/5)*3)
                    enemyx.append(boss.left+(boss.width/5)*4)

                    enemyy.append(boss.bottom-5)
                    enemyy.append(boss.bottom-5)
                    enemyy.append(boss.bottom-5)
                    enemyy.append(boss.bottom-5)

                    width = 30
                    height = round(width*1.66666666666666)
                    speed = 2
                    enemywidth.append(width)
                    enemywidth.append(width)
                    enemywidth.append(width)
                    enemywidth.append(width)
                    
                    enemyheight.append(height)
                    enemyheight.append(height)
                    enemyheight.append(height)
                    enemyheight.append(height)
                    
                    enemyhealth.append(ENEMYHEALTH)
                    enemyhealth.append(ENEMYHEALTH)
                    enemyhealth.append(ENEMYHEALTH)
                    enemyhealth.append(ENEMYHEALTH)
                    
                    enemymissileslowdown.append(ENEMYMISSILESLOWDOWN)
                    enemymissileslowdown.append(ENEMYMISSILESLOWDOWN)
                    enemymissileslowdown.append(ENEMYMISSILESLOWDOWN)
                    enemymissileslowdown.append(ENEMYMISSILESLOWDOWN)

                    enemyspeed.append(speed)
                    enemyspeed.append(speed)
                    enemyspeed.append(speed)
                    enemyspeed.append(speed)

                    enemydodgelist.append(True)
                    enemydodgelist.append(True)
                    enemydodgelist.append(True)
                    enemydodgelist.append(True)

                    bossenemyshootsoundeffect.play()
                bossmissilefirerate -= 1
                if bossmissilefirerate <= 0:
                    bossmissilefirerate = BOSSMISSILEFIRERATE
                    enemymissilex.append(boss.width/4+boss.left)
                    enemymissilex.append(2*boss.width/4+boss.left)
                    enemymissilex.append(3*boss.width/4+boss.left)

                    enemymissiley.append(boss.bottom - 3)
                    enemymissiley.append(boss.bottom - 3)
                    enemymissiley.append(boss.bottom - 3)

                loot =  int(.3*(BOSSHEALTH/MAXBOSSHEALTH)*500+50)        
                if bool(missiley):
                    u = 0
                    while u <= len(missiley) - 1:
                        missile = pygame.Rect(missilex[u] - .5*MISSILEWIDTH,  missiley[u]+MISSILELENGTH, MISSILEWIDTH, MISSILELENGTH)
                        missile.bottom = missiley[u]
                        missile.centerx = missilex[u]

                        if missile.colliderect(boss):
                            BOSSHEALTH -= MISSILEATTACK
                            cash += loot
                            lootlist.append(loot)
                            lootcenterx.append(missile.centerx)
                            lootcentery.append(missile.top)
                            lootcooldown.append(LOOTCOOLDOWN)
                          
                            if BOSSHEALTH <= 0:
                                winning = True
                                won = True
                            del missilex[u]
                            del missiley[u]
                            del missilepierce[u]
                            u -= 1
                        u +=1
                        
                if bool(missiletoplefty) or bool(missiletoprighty):
                    tl = 0
                    tr = 0
                    while tl <= len(missiletoplefty)-1 or tr <= len(missiletoprighty)-1:
                        if tl <= len(missiletoplefty)-1:
                            missiletl = pygame.Rect(missiletopleftx[tl] - .5*MISSILEWIDTH,  missiletoplefty[tl]+MISSILELENGTH, MISSILEWIDTH, MISSILELENGTH)
                            missiletl.bottom = missiletoplefty[tl]
                            missiletl.centerx = missiletopleftx[tl]
                            tl += 1

                            if missiletl.colliderect(boss):
                                BOSSHEALTH -= MISSILEATTACK
                                cash += loot
                                lootlist.append(loot)
                                lootcenterx.append(missiletl.centerx)
                                lootcentery.append(missiletl.top)
                                lootcooldown.append(LOOTCOOLDOWN)
                                del missiletopleftx[tl-1]
                                del missiletoplefty[tl-1]
                                del missiletopleftpierce[tl-1]
                                tl -= 1
                            
                                
                                if BOSSHEALTH <= 0:
                                    winning = True
                                    won = True   

                        if tr <= len(missiletoprighty)-1:
                            missiletr = pygame.Rect(missiletoprightx[tr] - .5*MISSILEWIDTH,  missiletoprighty[tr]+MISSILELENGTH, MISSILEWIDTH, MISSILELENGTH)
                            missiletr.bottom = missiletoprighty[tr]
                            missiletr.centerx = missiletoprightx[tr]
                            tr += 1

                            if missiletr.colliderect(boss):
                                BOSSHEALTH -= MISSILEATTACK
                                cash += loot
                                lootlist.append(loot)
                                lootcenterx.append(missiletr.centerx)
                                lootcentery.append(missiletr.top)
                                lootcooldown.append(LOOTCOOLDOWN)
                                del missiletoprightx[tr-1]
                                del missiletoprighty[tr-1]
                                del missiletoprightpierce[tr-1]
                                tr -= 1
                            
                                
                                if BOSSHEALTH <= 0:
                                    winning = True
                                    won = True
                                    break
                                
                            
                                          
              
                if bool(missilelefty):
                    l = -1
                    while l < len(missilelefty)-1:
                        l += 1
                        left = 0
                        missilelengthdivisor = (((600*.5)**2+(600-100)**2)**.5)*MISSILELENGTH
                        lengthx = ((((MISSILELENGTH **2)/((((600-100)/(.5*600))**2) + 1))**.5))+(600-100)/missilelengthdivisor
                        notcollide = True
                        y = missilelefty[l]- (600-100)/(.5*600)*lengthx

                        if boss.left <missileleftx[l]+.5*MISSILEWIDTH < boss.right or boss.left <missileleftx[l]-.5*MISSILEWIDTH- lengthx < boss.right:
                            if boss.top < missilelefty[l] < boss.bottom or boss.top < missilelefty[l] - (600-100)/(.5*600)* lengthx <boss.bottom:
                                while left< MISSILELENGTH and notcollide:
                                    left += .5

                                    missilelengthdivisor = (((600*.5)**2+(600-100)**2)**.5)*left
                                    lengthx = ((((left **2)/((((600-100)/(.5*600))**2) + 1))**.5))+(600-100)/missilelengthdivisor
                                    
                                    if boss.collidepoint(missileleftx[l] + .5*MISSILEWIDTH - lengthx, missilelefty[l]- (600-100)/(.5*600)*lengthx) or boss.collidepoint(missileleftx[l] - .5*MISSILEWIDTH - lengthx, missilelefty[l]- (600-100)/(.5*600)*lengthx):
                                        notcollide = False
                                        BOSSHEALTH -= MISSILEATTACK
                                        cash += loot
                                        lootlist.append(loot)
                                        lootcenterx.append(missileleftx[l] + .5*MISSILEWIDTH - lengthx)
                                        lootcentery.append(missilelefty[l]- (600-100)/(.5*600)*lengthx)
                                        lootcooldown.append(LOOTCOOLDOWN)
                                        del missileleftx[l]
                                        del missilelefty[l]
                                        del missileleftpierce[l]
                                        l -= 1
                                            
                                        if BOSSHEALTH<= 0:
                                            winning = won = True
                                            break

                                    else:
                                        if boss.collidepoint(missileleftx[l]+ lengthx, y) or boss.collidepoint(missileleftx[l] + MISSILEWIDTH*.25, y) or boss.collidepoint(missileleftx[l] - MISSILEWIDTH*.25, y):
                                            notcollide = False
                                            BOSSHEALTH -= MISSILEATTACK
                                            cash += loot
                                            lootlist.append(loot)
                                            lootcenterx.append(missileleftx[l] + .5*MISSILEWIDTH - lengthx)
                                            lootcentery.append(missilelefty[l]- (600-100)/(.5*600)*lengthx)
                                            lootcooldown.append(LOOTCOOLDOWN)
                                            del missileleftx[l]
                                            del missilelefty[l]
                                            del missileleftpierce[l]
                                            l -= 1
                                                
                                            if BOSSHEALTH <= 0:
                                                winning = won = True
                                                break

                            
                                
                if bool(missilerighty):
                    r = -1
                    while r < len(missilerighty)-1 :
                        r += 1
                        missilealive = True
                        right = 0
                        missilelengthdivisor = (((600*.5)**2+(600-100)**2)**.5)*MISSILELENGTH
                        lengthx = ((((MISSILELENGTH **2)/((((600-100)/(.5*600))**2) + 1))**.5))+(600-100)/missilelengthdivisor
                        y = missilerighty[r]- (600-100)/(.5*600)*lengthx
                        
                        notcollide = True
                        
                        if boss.left <missilerightx[r]-.5*MISSILEWIDTH < boss.right or boss.left <missilerightx[r]+.5*MISSILEWIDTH + lengthx < boss.right:
                            if boss.top < missilerighty[r] < boss.bottom or boss.top < missilerighty[r] - (600-100)/(.5*600)* lengthx <boss.bottom:
                                while right< MISSILELENGTH and notcollide:
                                    right += .5

                                    missilelengthdivisor = (((600*.5)**2+(600-100)**2)**.5)*right
                                    lengthx = ((((right **2)/((((600-100)/(.5*600))**2) + 1))**.5))+(600-100)/missilelengthdivisor
                                    
                                    
                                    if boss.collidepoint(missilerightx[r] - .5*MISSILEWIDTH + lengthx, y) or boss.collidepoint(missilerightx[r] + .5*MISSILEWIDTH + lengthx,y):
                                        notcollide = False
                                        BOSSHEALTH -= MISSILEATTACK
                                        cash += loot
                                        lootlist.append(loot)
                                        lootcenterx.append(missilerightx[r] - .5*MISSILEWIDTH + lengthx)
                                        lootcentery.append(y)
                                        lootcooldown.append(LOOTCOOLDOWN)
                                        del missilerightx[r]
                                        del missilerighty[r]
                                        del missilerightpierce[r]
                                        r -= 1
                                            
                                        if BOSSHEALTH <= 0:
                                            winning = won = True
                                            break
                                    else:
                                        if boss.collidepoint(missilerightx[r]+ lengthx, y) or boss.collidepoint(missilerightx[r] + MISSILEWIDTH*.25, y) or boss.collidepoint(missilerightx[r] - MISSILEWIDTH*.25, y):
                                            notcollide = False
                                            BOSSHEALTH -= MISSILEATTACK
                                            cash += loot
                                            lootlist.append(loot)
                                            lootcenterx.append(missilerightx[r] - .5*MISSILEWIDTH + lengthx)
                                            lootcentery.append(y)
                                            lootcooldown.append(LOOTCOOLDOWN)
                                            del missilerightx[r]
                                            del missilerighty[r]
                                            del missilerightpierce[r]
                                            r -= 1
                                                
                                            if BOSSHEALTH <= 0:
                                                winning = won = True
                                                break
                                    
                if bool(missilecentery):
                    u = 0
                    while u <= len(missilecentery)-1:
                        missile = pygame.Rect(missilecenterx[u] - .5*MISSILEWIDTH,  missilecentery[u]+MISSILELENGTH, MISSILEWIDTH, MISSILELENGTH)
                        missile.bottom = missilecentery[u]
                        missile.centerx = missilecenterx[u]
                        u +=1 

                        if missile.colliderect(boss):
                            BOSSHEALTH -= MISSILEATTACK
                            cash += loot
                            lootlist.append(loot)
                            lootcenterx.append(missile.centerx)
                            lootcentery.append(missile.top)
                            lootcooldown.append(LOOTCOOLDOWN)
                            del missilecenterx[u-1]
                            del missilecentery[u-1]
                            del missilecenterpierce[u-1]
                            u -= 1
                         
                            
                            if BOSSHEALTH <= 0:
                                winning = won = True
                                break
                            

                i += 1

                        
                


            if enemieskilled >=ENEMIESKILLED:
                ENEMYSPAWNPOINT += 10
                enemymissilefire = True
                if MAXENEMYSIZE > 20:
                    MAXENEMYSIZE -= 1
                if MINENEMYSIZE > 15:
                    MINENEMYSIZE -= 1
                if MAXENEMYSPEED < 6:
                    MAXENEMYSPEED += .5
                if MINENEMYSPEED < 3:
                    MINENEMYSPEED += .5
                if enemymissilefire:
                    if ENEMYMISSILESLOWDOWN > 10:
                        ENEMYMISSILESLOWDOWN -= 10
                        if ENEMYMISSILESLOWDOWN < 10:
                            ENEMYMISSILESLOWDOWN = 10
                    else:
                        ENEMYMISSILESLOWDOWN = 3
                        
                    if ENEMYMISSILESPEED <20:
                        ENEMYMISSILESPEED += .5                        
                    ENEMYMISSILEMOTIONSENSOR += 20
                    
                if ENEMYHEALTH >= MISSILEATTACK:
                    ENEMYHEALTH += MISSILEATTACK
                else:
                    ENEMYHEALTH = MISSILEATTACK
                enemieskilled = 0
                ENEMIESKILLED += 20

            if enemyspawnrateslowdown <= 0:
                enemyspawnrateslowdown = ENEMYSPAWNRATESLOWDOWN
                if ENEMYSPAWNRATE > 3:
                    ENEMYSPAWNRATE -= 5
                if ENEMYSPAWNRATE < 3:
                    ENEMYSPAWNRATE = 3
                ENEMYSPAWNRATESLOWDOWN += 5
                
            if enemymissilefire:
                i = 0
                soundplayed = False
                while i <= len(enemymissileslowdown)-1:
                    enemy = pygame.transform.scale(enemyImage, (enemywidth[i], int(round(enemywidth[i]*1.66666666666)))).get_rect()
                    enemy.centerx = enemyx[i]
                    enemy.top = enemyy[i]
                    
                    if enemy.left-ENEMYMISSILEMOTIONSENSOR <= player.right and enemy.right+ENEMYMISSILEMOTIONSENSOR >= player.left:
                        if enemymissileslowdown[i] <=0:
                            enemymissileslowdown[i] = ENEMYMISSILESLOWDOWN/movementchange
                            enemymissilex.append(enemy.centerx)
                            enemymissiley.append(enemy.bottom)
                            if enemymissilesoundeffectcountdown <= 0 and not soundplayed:
                                enemymissilesoundeffect.play()
                                enemymissilesoundeffectcountdown = (0/FPS)/movementchange
                            elif not soundplayed:
                                enemymissilesoundeffectcountdown -= 1
                            soundplayed = True
                            
                        else:
                            enemymissileslowdown[i] -= 1
                    i += 1
               
            

            scoredelay += 1
            if scoredelay >= SCOREDELAY:
                if not winning:
                    score += 1
                scoredelay = 0
            
            #Check for input
            if not firstloop:
                for event in pygame.event.get():
                    if event.type == QUIT:
                        pygame.quit()
                        sys.exit()
                    if event.type == MOUSEMOTION:
                        if event.pos[0] > GAMEWIDTH:
                            player.centerx = GAMEWIDTH
                        else:
                            player.centerx = event.pos[0]
                        player.centery = event.pos[1]
                    if event.type == MOUSEBUTTONDOWN:
                        if event.button == 1:
                            if not won:
                                if pausebutton.collidepoint(event.pos[0], event.pos[1]):
                                    pause = True
                                    tooexpensive = False
                                if quitlevelbutton.collidepoint(event.pos):
                                        areyousure = True
                                firemissile = True
                        if event.button == 3:
                            if not won:
                                pause = True
                                tooexpensive = False
                    if event.type == MOUSEBUTTONUP:
                        firemissile = False
                    if event.type == KEYDOWN:
                        if event.key == K_ESCAPE:
                            pygame.quit()
                            sys.exit()
                        if event.key == ord('l') and False:
                            trimissile = doublemissilefire = True
                            MISSILESLOWDOWN = MAXMISSILESLOWDOWN
                            MISSILESPEED = MAXMISSILESPEED
                            MISSILEWIDTH = MAXMISSILEWIDTH
                            MISSILELENGTH = MAXMISSILELENGTH
                            PLAYERWIDTH = MAXPLAYERWIDTH
                            PLAYERHEIGHT = 20
                            MISSILEPIERCE = MAXMISSILEPIERCE
                        if event.key == ord('f'):
                            if not fullscreen:
                                fullscreen = True
                                windowSurface = pygame.display.set_mode((WINDOWWIDTH, WINDOWHEIGHT), pygame.FULLSCREEN)
                            else:
                                fullscreen = False
                                windowSurface = pygame.display.set_mode((WINDOWWIDTH, WINDOWHEIGHT), 0, 32)
                        if event.key == ord('k'):
                            enemyx = []
                            enemyy = []
                            enemyhealth = []
                            enemywidth = []
                            enemyheight = []
                            enemyspeed = []
                            enemymissilex = []
                            enemymissiley = []
                            enemymissileslowdown = []
                            enemydodgelist = []
                        if event.key == ord('p'):
                            if not won:
                                pause = True
                                tooexpensive = False
                        if event.key == K_SPACE:
                            if not won:
                                tooexpensive = False
                                pause = True
                        if event.key == ord('s'):
                            if SLOWMOTION > 1:
                                SLOWMOTION = 1
                            else:
                                SLOWMOTION = 2

            # PAUSE
            pausebuttoncolor = (255,255,0)
            quitlevelbuttoncolor = (205,0,0)
            x = player.centerx
            y = player.centery
            tooexpensive = False
            while pause and not firstloop:
                windowSurface.fill(WINDOWCOLOR)
                
                i = 0
                pixArray = pygame.PixelArray(windowSurface)
                while i <= len(starx)-1:
                    if starx[i] < WINDOWWIDTH and stary[i] < WINDOWHEIGHT:
                        pixArray[starx[i]][stary[i]] = (255,255,255)
                    if stary[i] >= 768:
                        del starx[i]
                        del stary[i]
                        del starspeed[i]
                        i -= 1
                    i += 1
                del pixArray
                
                
                player.width = (PLAYERWIDTH)*(131/171)
                player.height = (PLAYERHEIGHT)*(280/299)
                player.centerx = x
                player.centery = y
                
                i = 0
                
                if quitlevelbutton.collidepoint(pygame.mouse.get_pos()):
                    quitlevelbuttoncolor = (255,80,80)
                else:
                    quitlevelbuttoncolor = (205,0,0)

                i = 0
                while i <= len(enemyx)-1:
                    enemy = pygame.transform.scale(enemyImage, (enemywidth[i], int(enemywidth[i]*1.66666666666)))
                    enemyRect = enemy.get_rect()
                    enemyRect.centerx = enemyx[i]
                    enemyRect.top = enemyy[i]
                    windowSurface.blit(enemy, enemyRect)
                    i += 1

                drawmissiles()
                i = 0                             
                while i <= len(enemymissilex)-1:  
                    enemymissile = pygame.Rect(0,0,ENEMYMISSILEWIDTH, ENEMYMISSILELENGTH)
                    enemymissile.centerx = enemymissilex[i]
                    enemymissile.centery = enemymissiley[i]
                    pygame.draw.rect(windowSurface, ENEMYMISSILECOLOR, enemymissile)
                    i += 1

                if not instructions:
                    playerStretchedImage = pygame.transform.scale(playerImage, (PLAYERWIDTH, PLAYERHEIGHT))
                    playerRect = playerStretchedImage.get_rect()
                    playerRect.centerx = player.centerx
                    playerRect.top = player.top
                    windowSurface.blit(playerStretchedImage, playerRect)
                    upgradedescriptionFont = pygame.font.SysFont(None, upgradedescriptionfontsize)

                if currentlevel == 2 and not won and not winning:
                    bossRect = bossImage.get_rect()
                    bossRect.center = boss.center
                    windowSurface.blit(bossImage, bossRect)

                if not tooexpensive:
                    upgradedescriptiontext = setuptext(upgradedescription, WHITE, upgradedescriptionFont)
                else:
                    upgradedescriptionfontsize = 23
                    upgradedescription = 'Too Expensive'
                    upgradedescriptiontext = setuptext(upgradedescription, WHITE, upgradedescriptionFont)

                pygame.draw.rect(windowSurface, (0,0,255), SIDEPANELRECT)

                pygame.draw.rect(windowSurface, quitlevelbuttoncolor, quitlevelbutton)
                windowSurface.blit(quitleveltext, quitlevelRect)

                pygame.draw.rect(windowSurface, pausebuttoncolor, pausedbutton)
                windowSurface.blit(pausedbuttontext, pausedtextRect)

                leveltext = setuptext('Level ' + str(currentlevel), WHITE, basicFont)                
                scoretext = setuptext('Score: ' + str(score), WHITE, scoreFont)
                highscoretext = setuptext('Highscore: ' + str(highscore), WHITE, scoreFont)
                cashtext = setuptext('Cash: $' + str(int(cash)), WHITE, scoreFont)
                if lives != 1:
                    livestext = setuptext('Lives: '+ str(lives), WHITE, scoreFont)
                else:
                    livestext = setuptext('Life: '+ str(lives), WHITE, scoreFont)

                
                if currentlevel == 1:
                    killstext = setuptext('Kills Left: ' + str(850-kills), WHITE, scoreFont)

                elif currentlevel == 2:
                    killstext = setuptext('', WHITE, scoreFont)
                    killsRect.width = 150
                    killsRect.height = 25
                    bosshealthbar = pygame.Rect(0,0,1,1)
                    bosshealthbar.width = (BOSSHEALTH/MAXBOSSHEALTH)*killsRect.width
                    bosshealthbar.height = killsRect.height
                    bosshealthbar.topleft = killsRect.topleft
                    pygame.draw.rect(windowSurface, (0,0,0), killsRect)
                    if BOSSHEALTH > 0:
                        pygame.draw.rect(windowSurface, (230,0,0), bosshealthbar)
                    killsRect.height = 50
                    
                elif currentlevel == 3:
                    killstext = setuptext('', WHITE, scoreFont)
               
                
                if doublemissilefire and trimissile or trimissile and currentlevel == 1:
                    missileupgradetext = setuptext('Missiles: MAX UPGRADE', (150,150,150), smallFont)
                else:
                    if cash < missileupgradecost:
                        missileupgradetext = setuptext('Missiles: $' + str(missileupgradecost), (150,150,150), smallFont)
                    else:                
                        missileupgradetext = setuptext('Missiles: $' + str(missileupgradecost), (255,225,100), smallFont)
                
                if cash < missileattackupgradecost:
                    if MISSILEATTACK >= ENEMYHEALTH:
                        missileattackupgradetext = setuptext('Missile Attack: Unavailable', (150,150,150), smallFont)
                    else:
                        missileattackupgradetext = setuptext('Missile Attack: $' + str(missileattackupgradecost), (150,150,150), smallFont)

                else:
                    if MISSILEATTACK >= ENEMYHEALTH:
                        missileattackupgradetext = setuptext('Missile Attack: Unavailable', (150,150,150), smallFont)
                    else:
                        missileattackupgradetext = setuptext('Missile Attack: $' + str(missileattackupgradecost), (255,225,100), smallFont)

                if MISSILEPIERCE >= MAXMISSILEPIERCE:
                    missilepierceupgradetext = setuptext('Missile Pierce: MAX UPGRADE', (150,150,150), smallFont)
                else:
                    if cash < missilepierceupgradecost:
                        missilepierceupgradetext = setuptext('Missile Pierce: $'+str(missilepierceupgradecost), (150,150,150), smallFont)
                    else:             
                        missilepierceupgradetext = setuptext('Missile Pierce: $' + str(missilepierceupgradecost), (255,225,100), smallFont)
                
                if MISSILESPEED >= MAXMISSILELENGTH * .5:
                    missilespeedupgradetext = setuptext('Missile Speed: MAX UPGRADE', (150,150,150), smallFont)
                else:
                    if cash < missilespeedupgradecost:
                        missilespeedupgradetext = setuptext('Missile Speed: $' + str(missilespeedupgradecost), (150,150,150), smallFont)
                    else:
                        missilespeedupgradetext = setuptext('Missile Speed: $' + str(missilespeedupgradecost), (255,225,100), smallFont)

            
                if MISSILESLOWDOWN == MAXMISSILESLOWDOWN:
                    missilerateupgradetext = setuptext('Missile Rate: MAX UPGRADE', (150,150,150), smallFont)
                else:
                    if cash < missilerateupgradecost:
                        missilerateupgradetext = setuptext('Missile Rate: $' + str(missilerateupgradecost), (150,150,150), smallFont)
                    else:
                        missilerateupgradetext = setuptext('Missile Rate: $' + str(missilerateupgradecost), (255,225,100), smallFont)

                if MISSILEWIDTH >= MAXMISSILEWIDTH:
                    missilewidthupgradetext = setuptext('Missile Width: MAX UPGRADE', (150,150,150), smallFont)
                else:
                    if cash <  missilewidthupgradecost:
                        missilewidthupgradetext = setuptext('Missile Width: $' + str(missilewidthupgradecost), (150,150,150), smallFont)
                    else:
                        missilewidthupgradetext = setuptext('Missile Width: $' + str(missilewidthupgradecost), (255,225,100), smallFont)
                        
                if PLAYERWIDTH <= MAXPLAYERWIDTH:
                    playersizeupgradetext = setuptext('Your Size: MAX UPGRADE', (150,150,150), smallFont)
                else:
                    if cash < playersizeupgradecost:
                        playersizeupgradetext = setuptext('Your Size: $' + str(playersizeupgradecost), (150,150,150), smallFont)
                    else:
                        playersizeupgradetext = setuptext('Your Size: $' + str(playersizeupgradecost), (255,225,100), smallFont)
                        

                missileupgradeRect = pygame.Rect(SIDEPANELRECT.left+5, upgradetitleRect.bottom +10, missileupgradetext.get_rect().width, missileupgradetext.get_rect().height)
                missileattackupgradeRect = pygame.Rect(SIDEPANELRECT.left+5, missileupgradeRect.bottom, missileattackupgradetext.get_rect().width, missileattackupgradetext.get_rect().height)
                missilepierceupgradeRect = pygame.Rect(SIDEPANELRECT.left+5, missileattackupgradeRect.bottom, missilepierceupgradetext.get_rect().width, missilepierceupgradetext.get_rect().height)
                missilespeedupgradeRect = pygame.Rect(SIDEPANELRECT.left+5, missilepierceupgradeRect.bottom, missilespeedupgradetext.get_rect().width, missilespeedupgradetext.get_rect().height)
                missilerateupgradeRect = pygame.Rect(SIDEPANELRECT.left+5, missilespeedupgradeRect.bottom, missilerateupgradetext.get_rect().width, missilerateupgradetext.get_rect().height)
                missilewidthupgradeRect = pygame.Rect(SIDEPANELRECT.left+5, missilerateupgradeRect.bottom, missilewidthupgradetext.get_rect().width, missilewidthupgradetext.get_rect().height)
                playersizeupgradeRect = pygame.Rect(SIDEPANELRECT.left+5, missilewidthupgradeRect.bottom, playersizeupgradetext.get_rect().width, playersizeupgradetext.get_rect().height)

                
                windowSurface.blit(missileupgradetext, missileupgradeRect)
                windowSurface.blit(missileattackupgradetext, missileattackupgradeRect)
                windowSurface.blit(missilepierceupgradetext, missilepierceupgradeRect)
                windowSurface.blit(missilespeedupgradetext, missilespeedupgradeRect)
                windowSurface.blit(missilerateupgradetext, missilerateupgradeRect)
                windowSurface.blit(missilewidthupgradetext, missilewidthupgradeRect)
                windowSurface.blit(playersizeupgradetext, playersizeupgradeRect)
                
                for event in pygame.event.get():
                    if event.type == QUIT:
                        pygame.quit()
                        sys.exit()
                    if event.type == KEYDOWN:
                        if event.key == K_ESCAPE:
                            pygame.quit()
                            sys.exit() 
                        if event.key == ord('l'):
                            trimissile = doublemissilefire = True
                            MISSILESLOWDOWN = MAXMISSILESLOWDOWN
                            MISSILESPEED = MAXMISSILESPEED
                            MISSILEWIDTH = MAXMISSILEWIDTH
                            MISSILELENGTH = MAXMISSILELENGTH
                            PLAYERWIDTH = MAXPLAYERWIDTH
                            PLAYERHEIGHT = 20
                            MISSILEPIERCE = MAXMISSILEPIERCE
                            
                        if event.key == ord('f'):
                            if not fullscreen:
                                fullscreen = True
                                windowSurface = pygame.display.set_mode((WINDOWWIDTH, WINDOWHEIGHT), pygame.FULLSCREEN)
                            else:
                                fullscreen = False                      
                                windowSurface = pygame.display.set_mode((WINDOWWIDTH, WINDOWHEIGHT), 0, 32)
                    if event.type == MOUSEMOTION:
                        tooexpensive = False
                        if missileupgradeRect.collidepoint(event.pos[0], event.pos[1]):
                            if not doublemissilefire and not trimissile:
                                upgradedescription = 'Two missiles shoot out front'
                                upgradedescriptionfontsize = 16
                                
                            elif doublemissilefire and not trimissile:
                                upgradedescription = 'Missiles shoot out diagonally too'
                                upgradedescriptionfontsize = 16

                            elif not doublemissilefire and trimissile and currentlevel > 1:
                                upgradedescription = 'Add Double Front Missiles'
                                upgradedescriptionfontsize = 22
                                
                            elif doublemissilefire and trimissile:
                                    upgradedescription = ''
                                    upgradedescriptionfontsize = 40
                                                        
                        else:                           
                            
                            if missileattackupgradeRect.collidepoint(event.pos[0], event.pos[1]):
                                upgradedescription = 'Upgrades Missile Attack by 1'
                                upgradedescriptionfontsize = 20
                            else:

                                if missilepierceupgradeRect.collidepoint(event.pos[0], event.pos[1]):
                                    if MISSILEPIERCE < MAXMISSILEPIERCE:
                                        upgradedescription = 'Increases missile pierce ability by 1'
                                        upgradedescriptionfontsize = 16
                                    else:
                                        upgradedescription = ''
                                        upgradedescriptionfontsize = 40                                    
                                else:
                                    if missilespeedupgradeRect.collidepoint(event.pos[0], event.pos[1]):
                                        if MISSILESPEED < MAXMISSILELENGTH * .5:
                                            upgradedescriptionfontsize = 20
                                            upgradedescription = 'Increases missile speed'
                                        else:
                                            upgradedescription = ''
                                            upgradedescriptionfontsize = 40                                        
                                    else:
                                        if missilerateupgradeRect.collidepoint(event.pos[0], event.pos[1]):
                                            if MISSILESLOWDOWN > MAXMISSILESLOWDOWN:
                                                upgradedescription = 'Increases Missile Fire Rate'
                                                upgradedescriptionfontsize = 20
                                            else:
                                                upgradedescription = ''
                                                upgradedescriptionfontsize = 40                                            
                                        else:
                                            if missilewidthupgradeRect.collidepoint(event.pos[0], event.pos[1]):
                                                if MISSILEWIDTH < MAXMISSILEWIDTH:
                                                    upgradedescription = 'Increases Missile Width'
                                                    upgradedescriptionfontsize = 20
                                                else:
                                                    upgradedescription = ''
                                                    upgradedescriptionfontsize = 40
                                            else:
                                                if playersizeupgradeRect.collidepoint(event.pos):
                                                    if PLAYERWIDTH > MAXPLAYERWIDTH:
                                                        upgradedescription = 'Decreases Player Size'
                                                        upgradedescriptionfontsize = 20
                                                    else:
                                                        upgradedescription = ''
                                                        upgradedescriptionfontsize = 40
                                                else:                                                 
                                                    upgradedescription = ''
                    if event.type == MOUSEBUTTONDOWN:

                        if event.button == 1:
                            tooexpensive = False                    
                            print(event.pos)
                            if player.collidepoint(event.pos):
                                print(event.pos)
                                pause = False

                            if quitlevelbutton.collidepoint(event.pos):
                                areyousure = True
                                pause = False
                            
                            if missileupgradeRect.collidepoint(event.pos[0], event.pos[1]):
                                if cash >= missileupgradecost:
                                    if not doublemissilefire and not trimissile:
                                        cash -= missileupgradecost
                                        doublemissilefire = True
                                        missileupgradecost = 10000
                                    elif doublemissilefire and not trimissile:
                                        cash -= missileupgradecost
                                        doublemissilefire = False
                                        trimissile = True
                                        missileupgradecost = 25000
                                    elif not doublemissilefire and trimissile and currentlevel > 1:
                                        cash -= missileupgradecost
                                        doublemissilefire = True
                                    elif  doublemissilefire and trimissile:
                                        upgradedescription = ''
                                        upgradedescriptionfontsize = 40
                                        maxupgrade = True
                                        missileupgradecost = 0
                                else:
                                    tooexpensive = True
                                
                                    
                            if missileattackupgradeRect.collidepoint(event.pos[0], event.pos[1]):
                                if MISSILEATTACK < ENEMYHEALTH:
                                    if cash>= missileattackupgradecost:
                                        cash -= missileattackupgradecost
                                        if ENEMYHEALTH-MISSILEATTACK< MISSILEATTACK:
                                            MISSILEATTACK = ENEMYHEALTH
                                        else:
                                            MISSILEATTACK += MISSILEATTACK
                                        missileattackupgradecost += 1000
                                    else:
                                        tooexpensive = True                                
                            if missilepierceupgradeRect.collidepoint(event.pos[0], event.pos[1]):
                                if MISSILEPIERCE< MAXMISSILEPIERCE:
                                    if cash >= missilepierceupgradecost:
                                        cash -= missilepierceupgradecost
                                        MISSILEPIERCE += 1
                                        missilepierceupgradecost += 500
                                    else:
                                        tooexpensive = True
                                else:
                                    upgradedescription = ''
                                    upgradedescriptionfontsize = 40
                            if missilespeedupgradeRect.collidepoint(event.pos[0], event.pos[1]):
                                if MISSILESPEED < MAXMISSILELENGTH*.5:
                                    if cash >= missilespeedupgradecost:
                                        cash -= missilespeedupgradecost
                                        MISSILESPEED += 1
                                        missilespeedupgradecost += 1000
                                    else:
                                        tooexpensive = True
                                else:
                                    upgradedescription = ''
                                    upgradedescriptionfontsize = 40
                            if missilerateupgradeRect.collidepoint(event.pos[0], event.pos[1]):
                                if MISSILESLOWDOWN > MAXMISSILESLOWDOWN:
                                    if cash >= missilerateupgradecost:
                                        if MISSILESLOWDOWN > 2:
                                            cash -= missilerateupgradecost
                                            MISSILESLOWDOWN -= 1
                                            if MISSILESLOWDOWN <= 1:
                                                MISSILESLOWDOWN = 2
                                            missilerateupgradecost += 500
                                    else:
                                        tooexpensive = True
                                else:
                                    upgradedescription = ''
                                    upgradedescriptionfontsize = 40

                            if missilewidthupgradeRect.collidepoint(event.pos[0], event.pos[1]):
                                if MISSILEWIDTH < MAXMISSILEWIDTH:
                                    if cash >= missilewidthupgradecost:                                
                                        cash -= missilewidthupgradecost
                                        MISSILEWIDTH += 1
                                        MISSILELENGTH +=.25
                                        missilewidthupgradecost += 500
                                    else:
                                        tooexpensive = True
                                else:
                                    upgradedescription = ''
                                    upgradedescriptionfontsize = 40

                            if playersizeupgradeRect.collidepoint(event.pos):
                                if PLAYERWIDTH > MAXPLAYERWIDTH:
                                    if cash >= playersizeupgradecost:
                                        cash -= playersizeupgradecost
                                        PLAYERWIDTH -= 3
                                        PLAYERHEIGHT -= 5
                                        if PLAYERWIDTH <= MAXPLAYERWIDTH:
                                            PLAYERWIDTH = MAXPLAYERWIDTH
                                            PLAYERHEIGHT = 20
                                        playersizeupgradecost += 500
                                    else:
                                        tooexpensive = True
    
                windowSurface.blit(leveltext, levelRect)
                windowSurface.blit(scoretext, scoreRect)
                windowSurface.blit(cashtext, cashRect)
                windowSurface.blit(highscoretext, highscoreRect)
                windowSurface.blit(livestext, livesRect)
                windowSurface.blit(killstext, killsRect)
                windowSurface.blit(upgradetitletext, upgradetitleRect)
                windowSurface.blit(upgradedescriptiontext, UPGRADEDESCRIPTIONRect)
                
                pygame.display.update()

                mainClock.tick(FPS)

                while instructions:
                    windowSurface.fill(WINDOWCOLOR)
                                    
                    i = 0
                    pixArray = pygame.PixelArray(windowSurface)
                    while i <= len(starx)-1:
                        stary[i] += starspeed[i]
                        if stary[i] < WINDOWHEIGHT and starx[i] < WINDOWWIDTH:
                            pixArray[starx[i]][stary[i]] = (255,255,255)
                        if stary[i]> 768:
                            del stary[i]
                            del starx[i]
                            del starspeed[i]
                            i -= 1
                        
                        i += 1

                    while len(starx)<MAXSTARS:
                        starx.append(random.randint(0,1366))
                        stary.append(0)
                        starspeed.append(random.randint(MINSTARSPEED,MAXSTARSPEED))

                    del pixArray
                    
                    pygame.draw.rect(windowSurface, (0,0,255), SIDEPANELRECT)
                    pygame.draw.rect(windowSurface, pausebuttoncolor, pausedbutton)
                    windowSurface.blit(pausedbuttontext, pausedtextRect)

                    pygame.draw.rect(windowSurface, quitlevelbuttoncolor, quitlevelbutton)
                    windowSurface.blit(quitleveltext, quitlevelRect)

                    windowSurface.blit(leveltext, levelRect)
                    windowSurface.blit(scoretext, scoreRect)
                    windowSurface.blit(cashtext, cashRect)
                    windowSurface.blit(highscoretext, highscoreRect)
                    windowSurface.blit(livestext, livesRect)
                    windowSurface.blit(killstext, killsRect)
                    windowSurface.blit(upgradedescriptiontext, UPGRADEDESCRIPTIONRect)

                    if quitlevelbutton.collidepoint(pygame.mouse.get_pos()):
                        quitlevelbuttoncolor = (255,80,80)
                    else:
                        quitlevelbuttoncolor = (205,0,0)

                    
                    
                    for event in pygame.event.get():
                        if event.type == QUIT:
                            pygame.quit()
                            sys.exit()


                        if event.type == KEYDOWN:
                            if event.key == K_ESCAPE:
                                pygame.quit()
                                sys.exit()                        
                            if event.key == ord('l'):
                                trimissile = doublemissilefire = True
                                MISSILESLOWDOWN = MAXMISSILESLOWDOWN
                                MISSILESPEED = MAXMISSILESPEED
                                MISSILEWIDTH = MAXMISSILEWIDTH
                                MISSILELENGTH = MAXMISSILELENGTH
                                PLAYERWIDTH = MAXPLAYERWIDTH
                                PLAYERHEIGHT = 20
                                MISSILEPIERCE = MAXMISSILEPIERCE    
                            if event.key == ord('f'):
                                if not fullscreen:
                                    fullscreen = True
                                    windowSurface = pygame.display.set_mode((WINDOWWIDTH, WINDOWHEIGHT), pygame.FULLSCREEN)
                                else:
                                    fullscreen = False                      
                                    windowSurface = pygame.display.set_mode((WINDOWWIDTH, WINDOWHEIGHT), 0, 32)
                        if event.type == MOUSEBUTTONDOWN:
                            if event.button == 1:
                                if player.collidepoint(event.pos):
                                    pause = False
                                    instructions =  False
                                if quitlevelbutton.collidepoint(event.pos):
                                    pause = False
                                    instructions = False
                                    game = False
                                    levelselect = True
                
                    if currentlevel == 1:
                        instructions1text = setuptext('Kill 850 enemies to defeat Level 1', WHITE, basicFont)
                        
                        instructions2text = setuptext('Don\'t die more than 4 times!!', WHITE, basicFont)

                    elif currentlevel == 2:
                        instructions1text = setuptext('Kill the Spaceshipinator', WHITE, basicFont)
                        
                        instructions2text = setuptext('You have 5 lives', WHITE, basicFont)

                    elif currentlevel == 3:
                        instructions1text = setuptext('Get every upgrade', WHITE, basicFont)
                        
                        instructions2text = setuptext('You have 3 lives', WHITE, basicFont)

                        
                    instructions1textRect = instructions1text.get_rect()
                    instructions1textRect.centerx = GAMEWIDTH/2
                    instructions1textRect.centery = WINDOWHEIGHT/3

                    instructions2textRect = instructions2text.get_rect()
                    instructions2textRect.centerx = GAMEWIDTH/2
                    instructions2textRect.centery = instructions1textRect.bottom+25

                    instructions3text = setuptext("(Click Spaceship to Start)", WHITE, smallFont)
                    instructions3textRect = instructions3text.get_rect()
                    instructions3textRect.centerx = GAMEWIDTH/2
                    instructions3textRect.centery = instructions2textRect.bottom+25

                    instructionsbackground = pygame.Rect(0,0,instructions1textRect.width+25, instructions1textRect.height+instructions2textRect.height +25)
                    instructionsbackground.centerx = instructions1textRect.centerx
                    instructionsbackground.centery = (instructions1textRect.centery+instructions2textRect.centery)/2

                    pygame.draw.rect(windowSurface, (0,0,0), instructionsbackground)
                    windowSurface.blit(instructions1text,instructions1textRect)
                    windowSurface.blit(instructions2text,instructions2textRect)
                    windowSurface.blit(instructions3text,instructions3textRect)
                        
                    


                    playerStretchedImage = pygame.transform.scale(playerImage, (PLAYERWIDTH, PLAYERHEIGHT))
                    playerRect = playerStretchedImage.get_rect()
                    playerRect.centerx = GAMEWIDTH/2
                    playerRect.centery = 3*WINDOWHEIGHT/4
                    windowSurface.blit(playerStretchedImage, playerRect)
                    player.center = (playerRect.center)

                    pygame.display.update()

                    mainClock.tick(FPS)
                iamnotsurecolor = (200,0,0)
                iamsurecolor = (0,170,0)
            if player.centerx < GAMEWIDTH -5 and not firstloop:
                pygame.mouse.set_pos(player.centerx, player.centery)
            
            mousex = pygame.mouse.get_pos()[0]
            mousey = pygame.mouse.get_pos()[1]
    
            if not firstloop:
                if pausebutton.collidepoint(pygame.mouse.get_pos()):
                    pausebuttoncolor = (255,100,255)
                else:
                    pausebuttoncolor = (255,30,187)

                if quitlevelbutton.collidepoint(pygame.mouse.get_pos()):
                    quitlevelbuttoncolor = (255,80,80)
                else:
                    quitlevelbuttoncolor = (205,0,0)
                
            
            # Record Missile start locations or wait to record
            if firemissile:
                if missileslow >= MISSILESLOWDOWN/movementchange:
                    missilesoundeffect.play()
                    if doublemissilefire:
                        missiletopleftx.append(player.centerx-10)
                        missiletoplefty.append(player.top)
                        missiletopleftpierce.append(MISSILEPIERCE)

                        missiletoprightx.append(player.centerx+10)
                        missiletoprighty.append(player.top)
                        missiletoprightpierce.append(MISSILEPIERCE)

                        missileslow = 0
                     
                
                    if trimissile:
                        if not doublemissilefire:
                            missileleftx.append(player.centerx)
                            missilelefty.append(player.top)
                            missileleftpierce.append(MISSILEPIERCE)
                                                
                            missilerightx.append(player.centerx)
                            missilerighty.append(player.top)
                            missilerightpierce.append(MISSILEPIERCE)

                            missilecenterx.append(player.centerx)
                            missilecentery.append(player.top)
                            missilecenterpierce.append(MISSILEPIERCE)
                            missileslow = 0
                        else:
                            missileleftx.append((player.centerx-10))
                            missilelefty.append(player.top)
                            missileleftpierce.append(MISSILEPIERCE)
                                                
                            missilerightx.append((player.centerx+10))
                            missilerighty.append(player.top)
                            missilerightpierce.append(MISSILEPIERCE)
                        
                    else:
                        if not doublemissilefire:
                            missilex.append(player.centerx)
                            missiley.append(player.top)
                            missilepierce.append(MISSILEPIERCE)
                            missileslow = 0
                else:
                    missileslow += 1
        
            else:
                missileslow += 1
            i = 0

      
            enemyspawnrate -= 1*movementchange
            if not won and currentlevel != 2:
                if len(enemyy)+kills >= 850 and currentlevel == 1:
                    i = len(enemyy)
                    while len(enemyy)+kills >850:
                        i -= 1
                        del enemyx[i]
                        del enemyy[i]
                        del enemywidth[i]
                        del enemyheight[i]
                        del enemyhealth[i]
                        del enemymissileslowdown[i]
                        del enemyspeed[i]
                        del enemydodgelist[i]
                        
                else:
                                        
                    if enemyspawnrate <= 0:
                        enemyspawnrate = ENEMYSPAWNRATE                        
                        width = random.randint(MINENEMYSIZE, MAXENEMYSIZE)
                        height = round(width*1.66666666666666)
                        speed = random.randint(int(MINENEMYSPEED), int(MAXENEMYSPEED))/ENEMYSPEEDDIVIDE
                        enemywidth.append(width)
                        enemyheight.append(height)
                        enemyx.append(random.randint(int(width*.5), int(GAMEWIDTH - width*.5)))
                        enemyy.append(0-height-ENEMYSPAWNPOINT)
                        enemyhealth.append(ENEMYHEALTH)
                        enemymissileslowdown.append(ENEMYMISSILESLOWDOWN)
                        enemydodgelist.append(False)
                        if speed > height:
                            speed = height
                        enemyspeed.append(speed)

            if bool(missiletoplefty) or bool(missiletoprighty):
                tl = 0
                tr = 0
                while tl <= len(missiletoplefty)-1 or tr <= len(missiletoprighty)-1:
                    
                    if tl <= len(missiletoplefty)-1:
                        if missiletoplefty[tl] <= 0:
                            del missiletoplefty[tl]
                            del missiletopleftx[tl]
                            del missiletopleftpierce[tl]
                            tl -=1
                    tl += 1 
                    
                    if tr <= len(missiletoprighty)-1:
                        if missiletoprighty[tr] <= 0:
                            del missiletoprighty[tr]
                            del missiletoprightx[tr]
                            del missiletoprightpierce[tr]
                            tr -=1
                    tr += 1 
            i = 0
            l = 0
            r = 0
            if bool(missilecentery) or bool(missilerighty) or bool(missilelefty):                
                while i <=len(missilecentery)-1 or l <= len(missilelefty)-1 or r <= len(missilerighty)-1:

                    if i <= len(missilecentery) - 1: 
                        if missilecentery[i] <=0:
                            del missilecentery[i]
                            del missilecenterx[i]
                            del missilecenterpierce[i]
                            i -=1
                    i += 1
                    
                    
                    if l <= len(missilelefty)-1:
                        if missilelefty[l] <= 0:
                            del missilelefty[l]
                            del missileleftx[l]
                            del missileleftpierce[l]
                            l -=1
                    l += 1 
                    
                    if r <= len(missilerighty)-1:
                        if missilerighty[r] <= 0:
                            del missilerighty[r]
                            del missilerightx[r]
                            del missilerightpierce[r]
                            r -=1
                    r += 1
                    
            if bool(missiley):
                i = 0
                while i <= len(missiley) - 1:
                    if missiley[i] <=0:
                            del missiley[i]
                            del missilex[i]
                            del missilepierce[i]
                            i -=1
                    i += 1

            
            if enemydodge:
                i = 0
                while i < len(enemydodgelist):
                    enemydodgelist[i] = True
                    i += 1
            i = 0
            while i <= len(enemyy)-1:
                enemydead = False
                enemy = pygame.Rect(0, 0, (enemywidth[i])*(131/171), enemyheight[i]*(255/299))
                enemy.centerx = enemyx[i]
                enemy.bottom = enemyy[i]+enemyheight[i]
                loot = int((MAXENEMYSIZE+50 - enemywidth[i]+enemyspeed[i]*2))+175
                points = int(MAXENEMYSIZE+50 - enemywidth[i]+enemyspeed[i]*2)*2
                if enemy.bottom > 0:
                         
                        if bool(missiley) and not enemydead:
                            u = 0
                            while u <= len(missiley) - 1 and not enemydead:
                                missile = pygame.Rect(missilex[u] - .5*MISSILEWIDTH,  missiley[u]-MISSILELENGTH, MISSILEWIDTH, MISSILELENGTH)
                        
                                if missile.colliderect(enemy):
                                    enemyhealth[i] -= MISSILEATTACK
                                    missilepierce[u] -= 1
                                    
                                    if enemyhealth[i] <= 0:
                                        enemydead = True
                                    if missilepierce[u] <= 0:
                                        del missilex[u]
                                        del missiley[u]
                                        del missilepierce[u]
                                        u -= 1
                                elif enemydodgelist[i]:
                                    if enemy.left <missile.left < enemy.right or enemy.left< missile.right < enemy.right:
                                        if enemy.bottom - missile.top <0:
                                            enemydodgelist[i] = False
                                            if enemy.centerx < missile.centerx:
                                                enemyx[i] -= enemyspeed[i]
                                            else:
                                                enemyx[i] += enemyspeed[i]
                                            enemyy[i] -= enemyspeed[i]/2
                                            while enemyx[i] > GAMEWIDTH:
                                                enemyx[i] -= 1
                                            while enemyx[i] < 0:
                                                enemyx[i] += 1
                                u +=1
                                
                        if bool(missiletoplefty) or bool(missiletoprighty):
                            tl = 0
                            tr = 0
                            while tl <= len(missiletoplefty)-1 or tr <= len(missiletoprighty)-1:
                                if enemydead:
                                    break
                                alreadydodged = False
                                
                                if tl <= len(missiletoplefty)-1:
                                    missiletl = pygame.Rect(missiletopleftx[tl] - .5*MISSILEWIDTH,  missiletoplefty[tl]+MISSILELENGTH, MISSILEWIDTH, MISSILELENGTH)
                                    missiletl.bottom = missiletoplefty[tl]
                                    missiletl.centerx = missiletopleftx[tl]
                                    tl += 1
                                    missiletldead = False

                                    if missiletl.colliderect(enemy):
                                        enemyhealth[i] -= MISSILEATTACK
                                        missiletopleftpierce[tl-1] -= 1

                                        if missiletopleftpierce[tl-1] <= 0:
                                            del missiletopleftx[tl-1]
                                            del missiletoplefty[tl-1]
                                            del missiletopleftpierce[tl-1]
                                            tl -= 1
                                            missiletldead = True
                                    
                                        
                                        if enemyhealth[i] <= 0:
                                            enemydead = True
                                            break
                                        
                                        
                                   

                                if tr <= len(missiletoprighty)-1:
                                    missiletr = pygame.Rect(missiletoprightx[tr] - .5*MISSILEWIDTH,  missiletoprighty[tr]+MISSILELENGTH, MISSILEWIDTH, MISSILELENGTH)
                                    missiletr.bottom = missiletoprighty[tr]
                                    missiletr.centerx = missiletoprightx[tr]
                                    tr += 1
                                    missiletrdead = False

                                    if missiletr.colliderect(enemy):
                                        enemyhealth[i] -= MISSILEATTACK
                                        missiletoprightpierce[tr-1] -= 1

                                        if missiletoprightpierce[tr-1] <= 0:
                                            del missiletoprightx[tr-1]
                                            del missiletoprighty[tr-1]
                                            del missiletoprightpierce[tr-1]
                                            tr -= 1
                                            missiletrdead = True
                                    
                                        
                                        if enemyhealth[i] <= 0:
                                            enemydead = True
                                            break
                                    elif enemydodgelist[i]:
                                        if not missiletldead and not missiletrdead:
                                            if enemy.bottom - missiletr.top <0:
                                                if enemy.left <missiletr.left < enemy.right or enemy.left< missiletr.right < enemy.right:
                                                    if enemy.left <missiletl.left < enemy.right or enemy.left< missiletl.right < enemy.right:
                                                        enemyx[i] += enemyspeed[i]
                                                    enemyy[i] -= enemyspeed[i]/2
                                                    enemydodgelist[i] = False
                                            

                                        if not missiletrdead:
                                            if enemy.bottom - missiletr.top <0:
                                                if enemy.left <missiletr.left < enemy.right or enemy.left< missiletr.right < enemy.right:                                        
                                                    if enemy.centerx < missiletr.centerx:
                                                        enemyx[i] -= enemyspeed[i]
                                                    elif not alreadydodged:
                                                        enemyx[i] += enemyspeed[i]
                                                    while enemyx[i] > GAMEWIDTH:
                                                        enemyx[i] -= 1
                                                    while enemyx[i] < 0:
                                                        enemyx[i] += 1
                                                    enemyy[i] -= enemyspeed[i]/2
                                                    enemydodgelist[i] = False
                                    
                                        if not missiletldead:
                                            if enemy.bottom - missiletl.top <0:
                                                if enemy.left <missiletl.left < enemy.right or enemy.left< missiletl.right < enemy.right:
                                                    if enemy.centerx < missiletl.centerx:
                                                        enemyx[i] -= enemyspeed[i]
                                                    else:
                                                        enemyx[i] += enemyspeed[i]
                                                    while enemyx[i] > GAMEWIDTH:
                                                        enemyx[i] -= 1
                                                    while enemyx[i] < 0:
                                                        enemyx[i] += 1
                                                    enemyy[i] -= enemyspeed[i]/2
                                                    enemydodgelist[i] = False
                                        
                                    
                                                  
                      
                        if bool(missilelefty) and not enemydead:
                            l = -1
                            while l < len(missilelefty)-1 and not enemydead:
                                l += 1
                                missilealive = True
                                left = 0
                                missilelengthdivisor = (((600*.5)**2+(600-100)**2)**.5)*MISSILELENGTH
                                lengthx = ((((MISSILELENGTH **2)/((((600-100)/(.5*600))**2) + 1))**.5))+(600-100)/missilelengthdivisor
                                notcollide = True
                                y = missilelefty[l]- (600-100)/(.5*600)*lengthx

                                if enemy.left <missileleftx[l]+.5*MISSILEWIDTH < enemy.right or enemy.left <missileleftx[l]-.5*MISSILEWIDTH- lengthx < enemy.right:
                                    if enemy.top < missilelefty[l] < enemy.bottom or enemy.top < missilelefty[l] - (600-100)/(.5*600)* lengthx <enemy.bottom:
                                        while left< MISSILELENGTH and notcollide and not enemydead:
                                            left += 1

                                            missilelengthdivisor = (((600*.5)**2+(600-100)**2)**.5)*left
                                            lengthx = ((((left **2)/((((600-100)/(.5*600))**2) + 1))**.5))+(600-100)/missilelengthdivisor
                                            
                                            if enemy.collidepoint(missileleftx[l] + .5*MISSILEWIDTH - lengthx, missilelefty[l]- (600-100)/(.5*600)*lengthx) or enemy.collidepoint(missileleftx[l] - .5*MISSILEWIDTH - lengthx, missilelefty[l]- (600-100)/(.5*600)*lengthx):
                                                notcollide = False
                                                enemyhealth[i] -= MISSILEATTACK
                                                missileleftpierce[l] -= 1
                                                
                                                if missileleftpierce[l] <= 0:
                                                    del missileleftx[l]
                                                    del missilelefty[l]
                                                    del missileleftpierce[l]
                                                    l -= 1
                                                    
                                                if enemyhealth[i] <= 0:
                                                    enemydead = True
                                                    break

                                            elif enemy.collidepoint(missileleftx[l]+ lengthx, y) or enemy.collidepoint(missileleftx[l] + MISSILEWIDTH*.25, y) or enemy.collidepoint(missileleftx[l] - MISSILEWIDTH*.25, y):
                                                    notcollide = False
                                                    enemyhealth[i] -= MISSILEATTACK
                                                    missileleftpierce[l] -= 1
                                                    
                                                    if missileleftpierce[l] <= 0:
                                                        del missileleftx[l]
                                                        del missilelefty[l]
                                                        del missileleftpierce[l]
                                                        l -= 1
                                                        
                                                    if enemyhealth[i] <= 0:
                                                        enemydead = True
                                                        break
                                            

                                    
                                        
                        if bool(missilerighty) and not enemydead:
                            r = -1
                            while r < len(missilerighty)-1 and not enemydead:
                                r += 1
                                missilealive = True
                                right = 0
                                missilelengthdivisor = (((600*.5)**2+(600-100)**2)**.5)*MISSILELENGTH
                                lengthx = ((((MISSILELENGTH **2)/((((600-100)/(.5*600))**2) + 1))**.5))+(600-100)/missilelengthdivisor
                                y = missilerighty[r]- (600-100)/(.5*600)*lengthx
                                
                                notcollide = True
                                
                                if enemy.left <missilerightx[r]-.5*MISSILEWIDTH < enemy.right or enemy.left <missilerightx[r]+.5*MISSILEWIDTH + lengthx < enemy.right:
                                    if enemy.top < missilerighty[r] < enemy.bottom or enemy.top < missilerighty[r] - (600-100)/(.5*600)* lengthx <enemy.bottom:
                                        while right< MISSILELENGTH and notcollide and not enemydead:
                                            right += 4

                                            missilelengthdivisor = (((600*.5)**2+(600-100)**2)**.5)*right
                                            lengthx = ((((right **2)/((((600-100)/(.5*600))**2) + 1))**.5))+(600-100)/missilelengthdivisor
                                            
                                            
                                            if enemy.collidepoint(missilerightx[r] - .5*MISSILEWIDTH + lengthx, y) or enemy.collidepoint(missilerightx[r] + .5*MISSILEWIDTH + lengthx,y):
                                                notcollide = False
                                                enemyhealth[i] -= MISSILEATTACK
                                                missilerightpierce[r] -= 1
                                                
                                                if missilerightpierce[r] <= 0:
                                                    del missilerightx[r]
                                                    del missilerighty[r]
                                                    del missilerightpierce[r]
                                                    r -= 1
                                                    
                                                if enemyhealth[i] <= 0:
                                                    enemydead = True
                                                    break
                                            else:
                                                if enemy.collidepoint(missilerightx[r]+ lengthx, y) or enemy.collidepoint(missilerightx[r] + MISSILEWIDTH*.25, y) or enemy.collidepoint(missilerightx[r] - MISSILEWIDTH*.25, y):
                                                    notcollide = False
                                                    enemyhealth[i] -= MISSILEATTACK
                                                    missilerightpierce[r] -= 1
                                                    
                                                    if missilerightpierce[r] <= 0:
                                                        del missilerightx[r]
                                                        del missilerighty[r]
                                                        del missilerightpierce[r]
                                                        r -= 1
                                                        
                                                    if enemyhealth[i] <= 0:
                                                        enemydead = True
                                                        break
                                            
                        if bool(missilecentery) and not enemydead:
                            u = 0
                            while u <= len(missilecentery)-1 and not enemydead:
                                missile = pygame.Rect(missilecenterx[u] - .5*MISSILEWIDTH,  missilecentery[u]+MISSILELENGTH, MISSILEWIDTH, MISSILELENGTH)
                                missile.bottom = missilecentery[u]
                                missile.centerx = missilecenterx[u]
                                u +=1 

                                if missile.colliderect(enemy):
                                    enemyhealth[i] -= MISSILEATTACK
                                    missilecenterpierce[u-1] -= 1
                                    
                                    if missilecenterpierce[u-1] <= 0:
                                        del missilecenterx[u-1]
                                        del missilecentery[u-1]
                                        del missilecenterpierce[u-1]
                                        u -= 1
                                 
                                    
                                    if enemyhealth[i] <= 0:
                                        enemydead = True                            
                                        break
                                elif enemydodgelist[i]:
                                    if enemy.left <missile.left < enemy.right or enemy.left< missile.right < enemy.right:
                                        if enemy.bottom - missile.top <0:
                                            if enemy.centerx < missile.centerx:
                                                enemyx[i] -= enemyspeed[i]
                                            else:
                                                enemyx[i] += enemyspeed[i]
                                            enemyy[i] -= enemyspeed[i]/2
                                            while enemyx[i] > GAMEWIDTH:
                                                enemyx[i] -= 1
                                            while enemyx[i] < 0:
                                                enemyx[i] += 1
                                            enemydodgelist[i] = False
                if enemydead:            
                    if winning:
                        winningkills += 1
                    score +=  points
                    cash += loot
                    lootlist.append(loot)
                    lootcenterx.append(enemy.centerx)
                    lootcentery.append(enemy.centery)
                    lootcooldown.append(LOOTCOOLDOWN)
                    enemieskilled += 1
                    enemyspawnrateslowdown -= 1
                    del enemyy[i]
                    del enemyx[i]
                    del enemywidth[i]
                    del enemyheight[i]
                    del enemyhealth[i]
                    del enemyspeed[i]
                    del enemymissileslowdown[i]
                    del enemydodgelist[i]
                    kills += 1
                    i -= 1
                    enemykilledsoundeffect.play()
                i += 1

            if score > highscore:
                highscore = score

            
            
            i = 0
            while i <= len(enemyy)-1:
                
                enemyy[i] += enemyspeed[i]*movementchange

                if enemyy[i] >= GAMEHEIGHT:
                    losscentery.append(enemyy[i])
                    losscenterx.append(enemyx[i]+enemywidth[i]/2)
                    losscooldown.append(LOSSCOOLDOWN)

                    if kills + len(enemyy) >= 850 and currentlevel == 1:
                        enemyy[i] = 0-enemyheight[i]
                    else:
                        del enemyy[i]
                        del enemyx[i]
                        del enemywidth[i]
                        del enemyheight[i]
                        del enemyhealth[i]
                        del enemyspeed[i]
                        del enemymissileslowdown[i]
                        del enemydodgelist[i]

                    if cash > MONEYLOST:
                        cash-= MONEYLOST
                    else:
                        cash = 0
                    score -= 20
                               
                    i -= 1
                elif enemyx[i] > GAMEWIDTH:
                    del enemyy[i]
                    del enemyx[i]
                    del enemywidth[i]
                    del enemyheight[i]
                    del enemyhealth[i]
                    del enemyspeed[i]
                    del enemymissileslowdown[i]
                    del enemydodgelist[i]
                    i -= 1
                i +=1

            enemyhit= False
            missileshot = False

            i = 0
            while i <= len(enemyx)-1:
                enemy = pygame.transform.scale(enemyImage, (enemywidth[i], enemyheight[i]))
                enemyRect = enemy.get_rect()
                enemyRect.centerx = enemyx[i]
                enemyRect.top = enemyy[i]
                windowSurface.blit(enemy, enemyRect)

                enemy2 = pygame.Rect(enemyx[i], enemyy[i], enemywidth[i]*(131/171), enemyheight[i]*(255/299))
                enemy2.centerx = enemyRect.centerx
                enemy2.bottom = enemyRect.bottom
                i += 1
                
                if player.colliderect(enemy2):
                    dead = True
                    enemyhit = True
                    justkilled = True
                    
                    break
        drawmissiles()
        if not dead:
            i = 0
            while i <= len(enemymissilex)-1:
                missilealive = True
                enemymissile = pygame.Rect(0,0,ENEMYMISSILEWIDTH, ENEMYMISSILELENGTH)
                enemymissile.centerx = enemymissilex[i]
                enemymissile.centery = enemymissiley[i]
                enemymissiley[i] += ENEMYMISSILESPEED*movementchange

                if enemymissile.top >= WINDOWHEIGHT:
                    missilealive = False
                    del enemymissilex[i]
                    del enemymissiley[i]
                    i -=1
                if missilealive:
                    if player.colliderect(enemymissile):
                        missileshot = True
                        dead = True
                        victor = enemymissile
                        justkilled = True
                        break
                        
                    pygame.draw.rect(windowSurface, ENEMYMISSILECOLOR, enemymissile)
                i += 1

        if dead:
            enemyx = []
            enemyy = []
            enemyhealth = []
            enemywidth = []
            enemyheight = []
            enemyspeed = []
            enemydodgelist = []
            enemieskilled = 0
            enemyspawnrate = 100
            
            enemymissilex = []
            enemymissiley = []
            enemymissileslowdown = []

            lootlist = []
            lootcenterx = []
            lootcentery = []
            lootcooldown = []
            losscentery = []
            losscenterx = []
            losscooldown = []

            missilex = []
            missiley = []
            missilepierce = []

            missilecentery = []
            missilecenterx = []
            missilecenterpierce = []
            missileleftx = []
            missilelefty = []
            missilerighty = []
            missilerightx = []
            missilerightpierce =[]
            missileleftpierce = []
            
            
            missiletoplefty = []
            missiletopleftx = []
            missiletopleftpierce = []
            
            missiletoprighty = []
            missiletoprightx = []
            missiletoprightpierce = []
            winningkills = 0
            if ENEMYMISSILEMOTIONSENSOR > -40:
                ENEMYMISSILEMOTIONSENSOR -= 4
            if ENEMYMISSILESPEED > 5:
                ENEMYMISSILESPEED -= 1
            if ENEMYMISSILESLOWDOWN < 80:
                ENEMYMISSILESLOWDOWN += 2
            if missileshot or enemyhit:    
                if justkilled:
                    deaths += 1
                    lives -= 1
            if ENEMYSPAWNRATE < int(FPS/2):
                ENEMYSPAWNRATE += 1
            if ENEMYHEALTH > MISSILEATTACK:
                ENEMYHEALTH -= MISSILEATTACK
            
            if MAXENEMYSPEED > 3:
                MAXENEMYSPEED -= .5
            else:
                MAXENEMYSPEED = 3
                
            if MINENEMYSPEED > 1:
                MINENEMYSPEED -= .5
            else:
                MINENEMYSPEED = 1
                    
            if cash > 5000:
                cash -= 5000
            else:
                cash = 0
            
            if score > highscore:
                highscore = score

            T = True
            outlineRectcolor = (50,50,100)
            returntomenucolor = (50,50,100)
            LEVELSELECTBUTTONCOLOR = (50,50,100)
            justkilled = False
            while T:
                windowSurface.fill(WINDOWCOLOR)
                
                i = 0
                pixArray = pygame.PixelArray(windowSurface)
                while i <= len(starx)-1:
                    stary[i] += starspeed[i]
                    if stary[i] < WINDOWHEIGHT and starx[i] < WINDOWWIDTH:
                        pixArray[starx[i]][stary[i]] = (255,255,255)
                    if stary[i] > 768:
                        del stary[i]
                        del starx[i]
                        del starspeed[i]
                        i -= 1
                                      
                    i += 1

                while len(starx)<MAXSTARS:
                    starx.append(random.randint(0,1366))
                    stary.append(0)
                    starspeed.append(random.randint(MINSTARSPEED,MAXSTARSPEED))

                del pixArray

                if currentlevel == 2 and bosshit:
                    bossRect = bossImage.get_rect()
                    bossRect.center = boss.center
                    windowSurface.blit(bossImage, bossRect)
                    

                score = 0
                if not wonlevel:
                    if lives<= 0:
                        gameovertext = setuptext('You were defeated', WHITE, giantFont)
                        gameoverRect = gameovertext.get_rect()
                        gameoverRect.top = 30
                        gameoverRect.centerx = WINDOWWIDTH/2
                    else:
                        gameovertext = setuptext('You died', WHITE, giantFont)
                        gameoverRect = gameovertext.get_rect()
                        gameoverRect.top = 30
                        gameoverRect.centerx = WINDOWWIDTH/2
                else:
                    gameovertext = setuptext('Level '+ str(currentlevel)+' Defeated', WHITE, giantFont)
                    gameoverRect = gameovertext.get_rect()
                    gameoverRect.top = 30
                    gameoverRect.centerx = WINDOWWIDTH/2

                if lives <= 0:
                    continueafterdeathtext = setuptext('Restart', WHITE, basicFont)
                    continueafterdeathRect = continueafterdeathtext.get_rect()
                    continueafterdeathRect.centerx = WINDOWWIDTH/2 
                    continueafterdeathRect.centery = WINDOWHEIGHT/2

                    outlineRect = pygame.Rect(0,0, 150, 45)
                elif wonlevel:
                    continueafterdeathtext = setuptext('Next Level', WHITE, basicFont)
                    continueafterdeathRect = continueafterdeathtext.get_rect()
                    continueafterdeathRect.centerx = WINDOWWIDTH/2 
                    continueafterdeathRect.centery = WINDOWHEIGHT/2
                    outlineRect = pygame.Rect(0,0, 190, 45)

                else:                    
                    continueafterdeathtext = setuptext('Continue', WHITE, basicFont)
                    continueafterdeathRect = continueafterdeathtext.get_rect()
                    continueafterdeathRect.centerx = WINDOWWIDTH/2 
                    continueafterdeathRect.centery = WINDOWHEIGHT/2
                    outlineRect = pygame.Rect(0,0, 170, 45)
                    
                outlineRect.centerx = WINDOWWIDTH/2
                outlineRect.centery = WINDOWHEIGHT/2

                levelselectbuttontext = setuptext('Level Select', WHITE, basicFont)
                levelselectbuttontextRect = levelselectbuttontext.get_rect()
                levelselectactualbutton = levelselectbuttontext.get_rect()

                levelselectactualbutton.height = 50
                levelselectactualbutton.centery = continueafterdeathRect.centery+60
                levelselectactualbutton.width = 225
                levelselectactualbutton.centerx = WINDOWWIDTH/2
                levelselectbuttontextRect.center = levelselectactualbutton.center

                returntomenutext = setuptext('Return to Title', WHITE, basicFont)
                returntomenuRect = returntomenutext.get_rect()
                returntomenuRect.centerx = WINDOWWIDTH/2
                returntomenuRect.centery = levelselectbuttontextRect.centery + 60

                returntomenubutton = pygame.Rect(0,0,returntomenuRect.width + 20, returntomenuRect.height+10)
                returntomenubutton.centerx = WINDOWWIDTH/2
                returntomenubutton.centery = returntomenuRect.centery

                for event in pygame.event.get():
                    if event.type == KEYDOWN:
                        if event.key == K_ESCAPE:
                            pygame.quit()
                            sys.exit()                                            
                        if event.key == ord('f'):
                            if not fullscreen:
                                fullscreen = True
                                windowSurface = pygame.display.set_mode((WINDOWWIDTH, WINDOWHEIGHT), pygame.FULLSCREEN)
                            else:
                                fullscreen = False                     
                                windowSurface = pygame.display.set_mode((WINDOWWIDTH, WINDOWHEIGHT), 0, 32)
                    if event.type == QUIT:
                        pygame.quit()
                        sys.exit
                    if event.type == MOUSEMOTION:
                        if continueafterdeathRect.collidepoint(event.pos[0], event.pos[1]):
                            outlineRectcolor = (100,100,255)
                        else:
                            outlineRectcolor = (50,50,100)
                            
                        if returntomenubutton.collidepoint(event.pos[0], event.pos[1]):
                            returntomenucolor = (100,100,255)
                        else:
                            returntomenucolor = (50,50,100)
                            
                        if levelselectactualbutton.collidepoint(event.pos):
                            LEVELSELECTBUTTONCOLOR = (100,100,255)
                        else:
                            LEVELSELECTBUTTONCOLOR = (50,50,100)
                            
                    if event.type == MOUSEBUTTONDOWN:
                        if outlineRect.collidepoint(event.pos[0], event.pos[1]):
                            T = False
                            dead = False
                            if event.pos[0] < GAMEWIDTH:
                                player.centerx = event.pos[0]
                                player.centery = event.pos[1]

                            else:
                                player.centery = event.pos[0]
                                player.centerx = GAMEWIDTH
                            if currentlevel == 2:
                                boss.center = (GAMEWIDTH/2, -30)
                                bossspeedslowdown = 150
                                bosshorizontalspeed = 0
                                bossverticalspeed = 10
                                bossenemyspawnrate = 60
                                bossmissilefirerate = 100
                                
                            if lives <= 0:
                                if currentlevel == 1:
                                    lives = 5
                                    cash = 0
                                    ENEMYSPAWNRATE = int(FPS/2)
                                    enemyspawnrate = int(FPS)
                                    
                                    MAXENEMYSIZE = 70
                                    MINENEMYSIZE = 20
                                    ENEMYHEALTH = 1
                                    MAXENEMYSPEED = 3 
                                    MINENEMYSPEED = 1
                                    ENEMYSPEEDDIVIDE = FPS/40
                                    ENEMYCASH = 10
                                    ENEMIESKILLED = 20
                                    enemieskilled = 0
                                    ENEMYSPAWNRATESLOWDOWN = 15
                                    enemyspawnrateslowdown = 5
                                    ENEMYDODGESPEED = 3
                                    ENEMYSPAWNPOINT = 0
                                                                        
                                    ENEMYMISSILESLOWDOWN = FPS*2
                                    ENEMYMISSILEMOTIONSENSOR = -40
                                    ENEMYMISSILESPEED = 200/FPS
                                    ENEMYMISSILEWIDTH = 5
                                    ENEMYMISSILELENGTH = 15

                                    
                                elif currentlevel == 2:
                                    lives = 5
                                    cash = 0
                                    BOSSHEALTH += BOSSHEALTH/5
                                    if BOSSHEALTH > MAXBOSSHEALTH:
                                        BOSSHEALTH = MAXBOSSHEALTH
                                elif currentlevel == 3:
                                    lives = 3
                                    cash = 0
                                                                        
                                kills = 0
                            if wonlevel:
                                currentlevel += 1
                                won = False
                                winning = False
                                MISSILESPEED = 320/FPS
                                MISSILEWIDTH = 5
                                MISSILELENGTH = 20
                                MISSILESLOWDOWN = FPS/2
                                MISSILEATTACK = 1
                                MISSILEPIERCE = 1
                                PLAYERWIDTH = 29
                                PLAYERHEIGHT = 50
                                doublemissilefire = False
                                trimissile = False
                                enemymissilefire = False
                        if returntomenubutton.collidepoint(event.pos):
                            T = False
                            dead = False
                            if not wonlevel:
                                areyousure = True
                                gototitlepage = True
                                gotolevelselect = False
                            else:
                                game = False
                                titlepage = True
                        if levelselectactualbutton.collidepoint(event.pos):
                            T = False
                            dead = False
                            if not wonlevel:
                                areyousure = True
                                gotolevelselect = True
                                gototitlepage = False
                            else:
                                game = False
                                levelselect = True
                            
                            

                pygame.draw.rect(windowSurface, outlineRectcolor, outlineRect)
                pygame.draw.rect(windowSurface, returntomenucolor, returntomenubutton)
                pygame.draw.rect(windowSurface, LEVELSELECTBUTTONCOLOR, levelselectactualbutton)

                windowSurface.blit(gameovertext, gameoverRect)
                windowSurface.blit(returntomenutext, returntomenuRect)
                windowSurface.blit(continueafterdeathtext, continueafterdeathRect)
                windowSurface.blit(levelselectbuttontext, levelselectbuttontextRect)

                if not wonlevel and not firstloop:
                    windowSurface.blit(playerStretchedImage, playerRect)
                if missileshot:
                    pygame.draw.rect(windowSurface, ENEMYMISSILECOLOR, victor)
                if enemyhit:
                    windowSurface.blit(enemy,  enemyRect)


                pygame.display.update()
                mainClock.tick(FPS)

        i = 0
        while i <= len(lootlist)-1:
            loottext = setuptext('+$' + str(lootlist[i]), (0,255,0), moneyFont)
            lootRect = pygame.Rect(0,0, loottext.get_rect().left, loottext.get_rect().top)
            lootRect.centerx = lootcenterx[i]
            lootRect.centery = lootcentery[i]
            windowSurface.blit(loottext, lootRect)
            lootcooldown[i] -= 1*movementchange
            lootcentery[i] -= 1*movementchange
            if lootcooldown[i] <= 0:
                del lootlist[i]
                del lootcentery[i]
                del lootcenterx[i]
                del lootcooldown[i]
                i -= 1
            i += 1
        i = 0
        while i <= len(losscenterx)-1:
            losstext = setuptext('-$' + str(MONEYLOST), (235,25,25), moneyFont)
            lossRect = pygame.Rect(0,0, losstext.get_rect().left, losstext.get_rect().top)
            lossRect.centerx = losscenterx[i]
            lossRect.centery = losscentery[i]
            windowSurface.blit(losstext, lossRect)
            losscooldown[i] -= 1*movementchange
            losscentery[i] -= 2*movementchange
            if losscooldown[i] <= 0:
                del losscenterx[i]
                del losscentery[i]
                del losscooldown[i]
                i-= 1

            i +=1
        wonlevel = False
        if winning:
            if won:
                if not winningnoisesplayed:
                    if False:
                            if currentlevel == 2:
                                bossdyingnoises.play()
                            else:
                                winningnoises.play()
                winningnoisesplayed = True
                enemyx = []
                enemyy = []
                enemyhealth = []
                enemywidth = []
                enemyheight = []
                enemyspeed = []
                enemymissilex = []
                enemymissiley = []
                enemymissileslowdown = []
                eulogy += 1
                if red >= redbottom:
                    red -= 5
                    redbottom = 5
                if red <= redbottom:
                    red += 7
                    redbottom = 248
                if green >= greenbottom:
                    green -= 12
                    greenbottom = 12
                if green <=greenbottom:
                    green += 4
                    greenbottom = 251
                if blue >= bluebottom:
                    blue -= 10
                    bluebottom = 10
                if blue <=bluebottom:
                    blue +=15
                    bluebottom = 240
                youwintextline1 = setuptext('LEVEL ' + str(currentlevel), (red, green, blue), giantFont)
                youwinRectline1 = youwintextline1.get_rect()
                youwinRectline1.centerx = GAMEWIDTH/2
                youwinRectline1.centery = WINDOWHEIGHT /3
                windowSurface.blit(youwintextline1, youwinRectline1)
                youwintextline2 = setuptext('DESTROYED', (red, green, blue), giantFont)
                youwinRectline2 = youwintextline2.get_rect()
                youwinRectline2.centerx = GAMEWIDTH/2
                youwinRectline2.top = youwinRectline1.bottom
                windowSurface.blit(youwintextline2, youwinRectline2)
                if eulogy >= 150:
                    victor = pygame.Rect(0,0,1,1)
                    missileupgradecost = 5000
                    missileattackupgradecost = 2000
                    missilepierceupgradecost = 3000
                    missilespeedupgradecost = 5000
                    missilerateupgradecost = 1000
                    missilewidthupgradecost = 3000
                    playersizeupgradecost = 1500
                    doublemissilefire = False
                    trimissile = False
                    cash = 0
                    MISSILEPIERCE = 1
                    MISSILEATTACK = 1
                    ENEMYHEALTH = 1
                    MISSILESPEED = 320/FPS
                    MISSILESLOWDOWN = FPS/2
                    MISSILELENGTH = 20
                    MISSILEWIDTH = 5
                    winning = False
                    won = False
                    dead = True
                    winningkills = 0
                    eulogy = 0
                    enemymissilefire = False
                    ENEMYMISSILESLOWDOWN = FPS*2
                    ENEMYMISSILEMOTIONSENSOR = -28
                    wonlevel = True
                    winningnoisesplayed = False
                
            else:
                

                if winningkillsred <= 255:
                    winningkillsred -= 10
                    if winningkillsred <0:
                        winningkillsred = 255

                if winningkillsblue <= 255:
                    winningkillsblue -= 10
                    if winningkillsblue <0:
                        winningkillsblue = 255

        if not areyousure and not game and not firstloop or game and not firstloop:
            playerStretchedImage = pygame.transform.scale(playerImage, (PLAYERWIDTH, PLAYERHEIGHT))
            playerRect = playerStretchedImage.get_rect()
            playerRect.centerx = player.centerx
            playerRect.top = player.top
            windowSurface.blit(playerStretchedImage, playerRect)
            pygame.draw.rect(windowSurface, (0,0,255), SIDEPANELRECT)

        leveltext = setuptext('Level ' + str(currentlevel), WHITE, basicFont)
        scoretext = setuptext('Score: ' + str(score), WHITE, scoreFont)
        highscoretext = setuptext('Highscore: ' + str(highscore), WHITE, scoreFont)
        cashtext = setuptext('Cash: $' + str(int(cash)), WHITE, scoreFont)

        if lives != 1:
            livestext = setuptext('Lives: '+ str(lives), WHITE, scoreFont)
        else:
            livestext = setuptext('Life: '+ str(lives), WHITE, scoreFont)
        
        if currentlevel == 1:
            killstext = setuptext('Kills Left: ' + str(850-kills), WHITE, scoreFont)

        elif currentlevel == 2:
            killstext = setuptext('', WHITE, scoreFont)
            killsRect.width = 150
            killsRect.height = 25
            bosshealthbar = pygame.Rect(0,0,1,1)
            bosshealthbar.width = (BOSSHEALTH/MAXBOSSHEALTH)*killsRect.width
            bosshealthbar.height = killsRect.height
            bosshealthbar.topleft = killsRect.topleft
            pygame.draw.rect(windowSurface, (0,0,0), killsRect)
            if BOSSHEALTH > 0:
                pygame.draw.rect(windowSurface, (230,0,0), bosshealthbar)
            
            killsRect.height = 50

            
        
        elif currentlevel == 3:
            killstext = setuptext('', WHITE, scoreFont)
            
        upgradesavailablecolor = (upgradesavailabletextred,upgradesavailabletextgreen,upgradesavailabletextblue)

        if addgreen:
            upgradesavailabletextgreen += 30*movementchange
            if upgradesavailabletextgreen >=255:
                upgradesavailabletextgreen =255
                addgreen = False
                minusred = True

        elif minusred:
            upgradesavailabletextred -= 30*movementchange
            if upgradesavailabletextred <= 0:
                upgradesavailabletextred = 0
                minusred = False
                addblue = True

        elif addblue:
            upgradesavailabletextblue += 30*movementchange
            if upgradesavailabletextblue >= 255:
                upgradesavailabletextblue = 255
                addblue = False
                minusgreen = True

        elif minusgreen:
            upgradesavailabletextgreen -= 30*movementchange
            if upgradesavailabletextgreen <=0:
                upgradesavailabletextgreen =0
                minusgreen = False
                addred = True
        
        elif addred:
            upgradesavailabletextred += 30*movementchange
            if upgradesavailabletextred >= 255:
                upgradesavailabletextred = 255
                addred = False
                minusblue = True

        elif minusblue:
            upgradesavailabletextblue -= 30*movementchange
            if upgradesavailabletextblue <= 0:
                upgradesavailabletextblue = 0
                minusblue = False
                addgreen = True

        
                
        

                
        if cash >= missileupgradecost and  not doublemissilefire or cash >= missileupgradecost and not trimissile:
            if not currentlevel == 1 and not trimissile:
                upgradeavailabletext = setuptext('Upgrades Available', upgradesavailablecolor, moneyFont)
                upgradeavailableRect = pygame.Rect(SIDEPANELRECT.left+5, SIDEPANELRECT.top + killsRect.bottom, SIDEPANELWIDTH, upgradeavailabletext.get_rect().bottom)
                windowSurface.blit(upgradeavailabletext, upgradeavailableRect)
        elif cash >= missileattackupgradecost and not MISSILEATTACK >= ENEMYHEALTH or cash>= missilepierceupgradecost and MISSILEPIERCE < MAXMISSILEPIERCE:        
            upgradeavailabletext = setuptext('Upgrades Available', upgradesavailablecolor, moneyFont)
            upgradeavailableRect = pygame.Rect(SIDEPANELRECT.left+5, SIDEPANELRECT.top + killsRect.bottom, SIDEPANELWIDTH, upgradeavailabletext.get_rect().bottom)
            windowSurface.blit(upgradeavailabletext, upgradeavailableRect)
        elif cash >= missilespeedupgradecost and MISSILESPEED < MAXMISSILESPEED:
            upgradeavailabletext = setuptext('Upgrades Available', upgradesavailablecolor, moneyFont)
            upgradeavailableRect = pygame.Rect(SIDEPANELRECT.left+5, SIDEPANELRECT.top + killsRect.bottom, SIDEPANELWIDTH, upgradeavailabletext.get_rect().bottom)
            windowSurface.blit(upgradeavailabletext, upgradeavailableRect)
        elif cash >= missilerateupgradecost and MISSILESLOWDOWN > MAXMISSILESLOWDOWN:
            upgradeavailabletext = setuptext('Upgrades Available', upgradesavailablecolor, moneyFont)
            upgradeavailableRect = pygame.Rect(SIDEPANELRECT.left+5, SIDEPANELRECT.top + killsRect.bottom, SIDEPANELWIDTH, upgradeavailabletext.get_rect().bottom)
            windowSurface.blit(upgradeavailabletext, upgradeavailableRect)
        elif cash >= missilewidthupgradecost and MISSILEWIDTH < MAXMISSILEWIDTH:
            upgradeavailabletext = setuptext('Upgrades Available', upgradesavailablecolor, moneyFont)
            upgradeavailableRect = pygame.Rect(SIDEPANELRECT.left+5, SIDEPANELRECT.top + killsRect.bottom, SIDEPANELWIDTH, upgradeavailabletext.get_rect().bottom)
            windowSurface.blit(upgradeavailabletext, upgradeavailableRect)
        elif cash >= playersizeupgradecost and PLAYERWIDTH > MAXPLAYERWIDTH:
            upgradeavailabletext = setuptext('Upgrades Available', upgradesavailablecolor, moneyFont)
            upgradeavailableRect = pygame.Rect(SIDEPANELRECT.left+5, SIDEPANELRECT.top + killsRect.bottom, SIDEPANELWIDTH, upgradeavailabletext.get_rect().bottom)
            windowSurface.blit(upgradeavailabletext, upgradeavailableRect)

        if not areyousure and not game and not firstloop or game and not firstloop :

            pygame.draw.rect(windowSurface, quitlevelbuttoncolor, quitlevelbutton)
            windowSurface.blit(quitleveltext, quitlevelRect)
            
            pygame.draw.rect(windowSurface, pausebuttoncolor, pausebutton)
            windowSurface.blit(pausebuttontext, pausetextRect)

            windowSurface.blit(leveltext, levelRect)
            windowSurface.blit(scoretext, scoreRect)
            windowSurface.blit(cashtext, cashRect)
            windowSurface.blit(highscoretext, highscoreRect)
            windowSurface.blit(livestext, livesRect)
            windowSurface.blit(killstext, killsRect)

        if  cashflow:
            cash += CASHFLOW
        if firstloop:
            if currentlevel == 2:
                PLAYERWIDTH = MAXPLAYERWIDTH
                PLAYERHEIGHT = 20

        # Check to see if the player has won
        if currentlevel == 1:
            enemydodge = False
            cashflow = False
            if kills >=  850:
                won = True
                winning = True
                kills = 850
        elif currentlevel == 2:
            ENEMYMISSILESPEED = 5
            if BOSSHEALTH > MAXBOSSHEALTH*3/4:
                BOSSENEMYSPAWNRATE = 55
                BOSSMISSILEFIRERATE = 25
                ENEMYMISSILESPEED = 4
                MAXBOSSSPEED = 10
            elif MAXBOSSHEALTH/2 < BOSSHEALTH < MAXBOSSHEALTH*3/4:
                BOSSENEMYSPAWNRATE = 43
                BOSSMISSILEFIRERATE = 18
                ENEMYMISSILESPEED = 6
                MAXBOSSSPEED = 14
                MINSTARSPEED = int((40/FPS)*1.5)
                MAXSTARSPEED = int((800/FPS)*1.5)
            elif MAXBOSSHEALTH/4 < BOSSHEALTH < MAXBOSSHEALTH/2:
                BOSSENEMYSPAWNRATE = 27
                BOSSMISSILEFIRERATE = 11
                ENEMYMISSILESPEED = 8
                MAXBOSSSPEED = 18
                MINSTARSPEED = int(((40/FPS)*1.25)*(8/6))
                MAXSTARSPEED = int(((800/FPS)*1.25)*(8/6))
            elif BOSSHEALTH < MAXBOSSHEALTH/4:
                BOSSENEMYSPAWNRATE = 14
                BOSSMISSILEFIRERATE = 4
                ENEMYMISSILESPEED = 10
                MAXBOSSSPEED = 22
                MINSTARSPEED = int(((40/FPS)*1.25)*(6/5)*(10/8))
                MAXSTARSPEED = int(((800/FPS)*1.25)*(6/5)*(10/8))
            enemydodge = True
            cashflow = False #True
            CASHFLOW = 3 #7
            if cash >= 500000:
                won = True
                winning = True
                cash = 500000
        elif currentlevel == 3:
            enemydodge = True
            cashflow = True
            CASHFLOW  = 4
            if MISSILESLOWDOWN <= MAXMISSILESLOWDOWN and MISSILEWIDTH >= MAXMISSILEWIDTH and MISSILELENGTH >= MAXMISSILELENGTH and PLAYERWIDTH <= MAXPLAYERWIDTH and MISSILEPIERCE >= MAXMISSILEPIERCE and MISSILESPEED >= MAXMISSILESPEED:
                won = True
                winning = True
        elif currentlevel == 4:
            if cash >= 250000:
                won = True
                winning = True
        current_fps = mainClock.get_fps()
        fpsdisplaytext = setuptext(str(current_fps), WHITE, scoreFont)
        windowSurface.blit(fpsdisplaytext, fpsdisplayRect)
        movementchange = FPS/current_fps

        if firstloop:
                ENEMYSPAWNRATE = 10
                        
        if not areyousure:
            pygame.display.update()
        
        
        mainClock.tick(FPS/SLOWMOTION)
        firstloop =  False  
        

