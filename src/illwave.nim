import os, unicode, bitops
from colors import nil
from terminal import nil
from sequtils import nil

type
  ForegroundColor* = enum   ## Foreground colors
    fgNone = 0,             ## default
    fgBlack = 30,           ## black
    fgRed,                  ## red
    fgGreen,                ## green
    fgYellow,               ## yellow
    fgBlue,                 ## blue
    fgMagenta,              ## magenta
    fgCyan,                 ## cyan
    fgWhite,                ## white

  BackgroundColor* = enum   ## Background colors
    bgNone = 0,             ## default (transparent)
    bgBlack = 40,           ## black
    bgRed,                  ## red
    bgGreen,                ## green
    bgYellow,               ## yellow
    bgBlue,                 ## blue
    bgMagenta,              ## magenta
    bgCyan,                 ## cyan
    bgWhite,                ## white

  Key* {.pure.} = enum      ## Supported single key presses and key combinations
    Mouse  = (-2, "Mouse")
    None   = (-1, "None"),

    # Special ASCII characters
    CtrlA  = (1, "CtrlA"),
    CtrlB  = (2, "CtrlB"),
    CtrlC  = (3, "CtrlC"),
    CtrlD  = (4, "CtrlD"),
    CtrlE  = (5, "CtrlE"),
    CtrlF  = (6, "CtrlF"),
    CtrlG  = (7, "CtrlG"),
    CtrlH  = (8, "CtrlH"),
    Tab    = (9, "Tab"),     # Ctrl-I
    CtrlJ  = (10, "CtrlJ"),
    CtrlK  = (11, "CtrlK"),
    CtrlL  = (12, "CtrlL"),
    Enter  = (13, "Enter"),  # Ctrl-M
    CtrlN  = (14, "CtrlN"),
    CtrlO  = (15, "CtrlO"),
    CtrlP  = (16, "CtrlP"),
    CtrlQ  = (17, "CtrlQ"),
    CtrlR  = (18, "CtrlR"),
    CtrlS  = (19, "CtrlS"),
    CtrlT  = (20, "CtrlT"),
    CtrlU  = (21, "CtrlU"),
    CtrlV  = (22, "CtrlV"),
    CtrlW  = (23, "CtrlW"),
    CtrlX  = (24, "CtrlX"),
    CtrlY  = (25, "CtrlY"),
    CtrlZ  = (26, "CtrlZ"),
    Escape = (27, "Escape"),

    CtrlBackslash    = (28, "CtrlBackslash"),
    CtrlRightBracket = (29, "CtrlRightBracket"),

    # Printable ASCII characters
    Space           = (32, "Space"),
    ExclamationMark = (33, "ExclamationMark"),
    DoubleQuote     = (34, "DoubleQuote"),
    Hash            = (35, "Hash"),
    Dollar          = (36, "Dollar"),
    Percent         = (37, "Percent"),
    Ampersand       = (38, "Ampersand"),
    SingleQuote     = (39, "SingleQuote"),
    LeftParen       = (40, "LeftParen"),
    RightParen      = (41, "RightParen"),
    Asterisk        = (42, "Asterisk"),
    Plus            = (43, "Plus"),
    Comma           = (44, "Comma"),
    Minus           = (45, "Minus"),
    Dot             = (46, "Dot"),
    Slash           = (47, "Slash"),

    Zero  = (48, "Zero"),
    One   = (49, "One"),
    Two   = (50, "Two"),
    Three = (51, "Three"),
    Four  = (52, "Four"),
    Five  = (53, "Five"),
    Six   = (54, "Six"),
    Seven = (55, "Seven"),
    Eight = (56, "Eight"),
    Nine  = (57, "Nine"),

    Colon        = (58, "Colon"),
    Semicolon    = (59, "Semicolon"),
    LessThan     = (60, "LessThan"),
    Equals       = (61, "Equals"),
    GreaterThan  = (62, "GreaterThan"),
    QuestionMark = (63, "QuestionMark"),
    At           = (64, "At"),

    ShiftA  = (65, "ShiftA"),
    ShiftB  = (66, "ShiftB"),
    ShiftC  = (67, "ShiftC"),
    ShiftD  = (68, "ShiftD"),
    ShiftE  = (69, "ShiftE"),
    ShiftF  = (70, "ShiftF"),
    ShiftG  = (71, "ShiftG"),
    ShiftH  = (72, "ShiftH"),
    ShiftI  = (73, "ShiftI"),
    ShiftJ  = (74, "ShiftJ"),
    ShiftK  = (75, "ShiftK"),
    ShiftL  = (76, "ShiftL"),
    ShiftM  = (77, "ShiftM"),
    ShiftN  = (78, "ShiftN"),
    ShiftO  = (79, "ShiftO"),
    ShiftP  = (80, "ShiftP"),
    ShiftQ  = (81, "ShiftQ"),
    ShiftR  = (82, "ShiftR"),
    ShiftS  = (83, "ShiftS"),
    ShiftT  = (84, "ShiftT"),
    ShiftU  = (85, "ShiftU"),
    ShiftV  = (86, "ShiftV"),
    ShiftW  = (87, "ShiftW"),
    ShiftX  = (88, "ShiftX"),
    ShiftY  = (89, "ShiftY"),
    ShiftZ  = (90, "ShiftZ"),

    LeftBracket  = (91, "LeftBracket"),
    Backslash    = (92, "Backslash"),
    RightBracket = (93, "RightBracket"),
    Caret        = (94, "Caret"),
    Underscore   = (95, "Underscore"),
    GraveAccent  = (96, "GraveAccent"),

    A = (97, "A"),
    B = (98, "B"),
    C = (99, "C"),
    D = (100, "D"),
    E = (101, "E"),
    F = (102, "F"),
    G = (103, "G"),
    H = (104, "H"),
    I = (105, "I"),
    J = (106, "J"),
    K = (107, "K"),
    L = (108, "L"),
    M = (109, "M"),
    N = (110, "N"),
    O = (111, "O"),
    P = (112, "P"),
    Q = (113, "Q"),
    R = (114, "R"),
    S = (115, "S"),
    T = (116, "T"),
    U = (117, "U"),
    V = (118, "V"),
    W = (119, "W"),
    X = (120, "X"),
    Y = (121, "Y"),
    Z = (122, "Z"),

    LeftBrace  = (123, "LeftBrace"),
    Pipe       = (124, "Pipe"),
    RightBrace = (125, "RightBrace"),
    Tilde      = (126, "Tilde"),
    Backspace  = (127, "Backspace"),

    # Special characters with virtual keycodes
    Up       = (1001, "Up"),
    Down     = (1002, "Down"),
    Right    = (1003, "Right"),
    Left     = (1004, "Left"),
    Home     = (1005, "Home"),
    Insert   = (1006, "Insert"),
    Delete   = (1007, "Delete"),
    End      = (1008, "End"),
    PageUp   = (1009, "PageUp"),
    PageDown = (1010, "PageDown"),

    F1  = (1011, "F1"),
    F2  = (1012, "F2"),
    F3  = (1013, "F3"),
    F4  = (1014, "F4"),
    F5  = (1015, "F5"),
    F6  = (1016, "F6"),
    F7  = (1017, "F7"),
    F8  = (1018, "F8"),
    F9  = (1019, "F9"),
    F10 = (1020, "F10"),
    F11 = (1021, "F11"),
    F12 = (1022, "F12"),

  IllwaveError* = object of Exception

type
  MouseButtonAction* {.pure.} = enum
    mbaNone, mbaPressed, mbaReleased
  MouseInfo* = object
    x*: int ## x mouse position
    y*: int ## y mouse position
    button*: MouseButton ## which button was pressed
    action*: MouseButtonAction ## if button was released or pressed
    ctrl*: bool ## was ctrl was down on event
    shift*: bool ## was shift was down on event
    scroll*: bool ## if this is a mouse scroll
    scrollDir*: ScrollDirection
    move*: bool ## if this a mouse move
  MouseButton* {.pure.} = enum
    mbNone, mbLeft, mbMiddle, mbRight
  ScrollDirection* {.pure.} = enum
    sdNone, sdUp, sdDown

func toKey(c: int): Key =
  try:
    result = Key(c)
  except RangeError:  # ignore unknown keycodes
    result = Key.None

var gIllwaveInitialized* = false

when defined(windows):
  import encodings, unicode, winlean

  proc kbhit(): cint {.importc: "_kbhit", header: "<conio.h>".}
  proc getch(): cint {.importc: "_getch", header: "<conio.h>".}

  proc getConsoleMode(hConsoleHandle: Handle, dwMode: ptr DWORD): WINBOOL {.
      stdcall, dynlib: "kernel32", importc: "GetConsoleMode".}

  proc setConsoleMode(hConsoleHandle: Handle, dwMode: DWORD): WINBOOL {.
      stdcall, dynlib: "kernel32", importc: "SetConsoleMode".}

  # Mouse
  const
    INPUT_BUFFER_LEN = 512
  const
    ENABLE_MOUSE_INPUT = 0x10
    ENABLE_WINDOW_INPUT = 0x8
    ENABLE_QUICK_EDIT_MODE = 0x40
    ENABLE_EXTENDED_FLAGS = 0x80
    MOUSE_EVENT = 0x0002

  const
    FROM_LEFT_1ST_BUTTON_PRESSED = 0x0001
    FROM_LEFT_2ND_BUTTON_PRESSED = 0x0004
    RIGHTMOST_BUTTON_PRESSED = 0x0002

  const
    LEFT_CTRL_PRESSED = 0x0008
    RIGHT_CTRL_PRESSED = 0x0004
    SHIFT_PRESSED = 0x0010

  const
    MOUSE_WHEELED = 0x0004

  type
    WCHAR = WinChar
    CHAR = char
    BOOL = WINBOOL
    WORD = uint16
    UINT = cint
    SHORT = int16

  # The windows console input structures.
  type
    KEY_EVENT_RECORD_UNION* {.bycopy, union.} = object
      UnicodeChar*: WCHAR
      AsciiChar*: CHAR

    INPUT_RECORD_UNION* {.bycopy, union.} = object
      KeyEvent*: KEY_EVENT_RECORD
      MouseEvent*: MOUSE_EVENT_RECORD
      WindowBufferSizeEvent*: WINDOW_BUFFER_SIZE_RECORD
      MenuEvent*: MENU_EVENT_RECORD
      FocusEvent*: FOCUS_EVENT_RECORD

    COORD* {.bycopy.} = object
      X*: SHORT
      Y*: SHORT

    PCOORD* = ptr COORD
    FOCUS_EVENT_RECORD* {.bycopy.} = object
      bSetFocus*: BOOL

    KEY_EVENT_RECORD* {.bycopy.} = object
      bKeyDown*: BOOL
      wRepeatCount*: WORD
      wVirtualKeyCode*: WORD
      wVirtualScanCode*: WORD
      uChar*: KEY_EVENT_RECORD_UNION
      dwControlKeyState*: DWORD

    MENU_EVENT_RECORD* {.bycopy.} = object
      dwCommandId*: UINT

    PMENU_EVENT_RECORD* = ptr MENU_EVENT_RECORD
    MOUSE_EVENT_RECORD* {.bycopy.} = object
      dwMousePosition*: COORD
      dwButtonState*: DWORD
      dwControlKeyState*: DWORD
      dwEventFlags*: DWORD

    WINDOW_BUFFER_SIZE_RECORD* {.bycopy.} = object
      dwSize*: COORD

    INPUT_RECORD* {.bycopy.} = object
      EventType*: WORD
      Event*: INPUT_RECORD_UNION

  type
    PINPUT_RECORD = ptr array[INPUT_BUFFER_LEN, INPUT_RECORD]
    LPDWORD = PDWORD

  proc peekConsoleInputA(hConsoleInput: HANDLE, lpBuffer: PINPUT_RECORD, nLength: DWORD, lpNumberOfEventsRead: LPDWORD): WINBOOL
    {.stdcall, dynlib: "kernel32", importc: "PeekConsoleInputA".}

  const
    ENABLE_WRAP_AT_EOL_OUTPUT   = 0x0002

  var gOldConsoleModeInput: DWORD
  var gOldConsoleMode: DWORD

  proc consoleInit() =
    discard getConsoleMode(getStdHandle(STD_INPUT_HANDLE), gOldConsoleModeInput.addr)
    if getConsoleMode(getStdHandle(STD_OUTPUT_HANDLE), gOldConsoleMode.addr) != 0:
      var mode = gOldConsoleMode and (not ENABLE_WRAP_AT_EOL_OUTPUT)
      discard setConsoleMode(getStdHandle(STD_OUTPUT_HANDLE), mode)

  proc consoleDeinit() =
    if gOldConsoleMode != 0:
      discard setConsoleMode(getStdHandle(STD_OUTPUT_HANDLE), gOldConsoleMode)


  func getKeyAsync(): Key =
    var key = Key.None

    if kbhit() > 0:
      let c = getch()
      case c:
      of   0:
        case getch():
        of 59: key = Key.F1
        of 60: key = Key.F2
        of 61: key = Key.F3
        of 62: key = Key.F4
        of 63: key = Key.F5
        of 64: key = Key.F6
        of 65: key = Key.F7
        of 66: key = Key.F8
        of 67: key = Key.F9
        of 68: key = Key.F10
        else: discard getch()  # ignore unknown 2-key keycodes

      of   8: key = Key.Backspace
      of   9: key = Key.Tab
      of  13: key = Key.Enter
      of  32: key = Key.Space

      of 224:
        case getch():
        of  72: key = Key.Up
        of  75: key = Key.Left
        of  77: key = Key.Right
        of  80: key = Key.Down

        of  71: key = Key.Home
        of  82: key = Key.Insert
        of  83: key = Key.Delete
        of  79: key = Key.End
        of  73: key = Key.PageUp
        of  81: key = Key.PageDown

        of 133: key = Key.F11
        of 134: key = Key.F12
        else: discard  # ignore unknown 2-key keycodes

      else:
        key = toKey(c)
    result = key


  proc writeConsole(hConsoleOutput: HANDLE, lpBuffer: pointer,
                    nNumberOfCharsToWrite: DWORD,
                    lpNumberOfCharsWritten: ptr DWORD,
                    lpReserved: pointer): WINBOOL {.
    stdcall, dynlib: "kernel32", importc: "WriteConsoleW".}

  var hStdout = getStdHandle(STD_OUTPUT_HANDLE)
  var utf16LEConverter = open(destEncoding = "utf-16", srcEncoding = "UTF-8")

  proc put(s: string) =
    var us = utf16LEConverter.convert(s)
    var numWritten: DWORD
    discard writeConsole(hStdout, pointer(us[0].addr), DWORD(s.runeLen),
                         numWritten.addr, nil)

else:  # OS X & Linux
  import posix, tables, termios
  import strutils, strformat

  proc consoleInit()
  proc consoleDeinit()

  # Mouse
  # https://de.wikipedia.org/wiki/ANSI-Escapesequenz
  # https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Extended-coordinates
  const
    CSI = 0x1B.chr & 0x5B.chr
    SET_BTN_EVENT_MOUSE = "1002"
    SET_ANY_EVENT_MOUSE = "1003"
    SET_SGR_EXT_MODE_MOUSE = "1006"
    # SET_URXVT_EXT_MODE_MOUSE = "1015"
    ENABLE = "h"
    DISABLE = "l"
    MouseTrackAny = fmt"{CSI}?{SET_BTN_EVENT_MOUSE}{ENABLE}{CSI}?{SET_ANY_EVENT_MOUSE}{ENABLE}{CSI}?{SET_SGR_EXT_MODE_MOUSE}{ENABLE}"
    DisableMouseTrackAny = fmt"{CSI}?{SET_BTN_EVENT_MOUSE}{DISABLE}{CSI}?{SET_ANY_EVENT_MOUSE}{DISABLE}{CSI}?{SET_SGR_EXT_MODE_MOUSE}{DISABLE}"

  # Adapted from:
  # https://ftp.gnu.org/old-gnu/Manuals/glibc-2.2.3/html_chapter/libc_24.html#SEC499
  proc SIGTSTP_handler(sig: cint) {.noconv.} =
    signal(SIGTSTP, SIG_DFL)
    # XXX why don't the below 3 lines seem to have any effect?
    terminal.resetAttributes()
    terminal.showCursor()
    consoleDeinit()
    discard posix.raise(SIGTSTP)

  proc SIGCONT_handler(sig: cint) {.noconv.} =
    signal(SIGCONT, SIGCONT_handler)
    signal(SIGTSTP, SIGTSTP_handler)

    consoleInit()
    terminal.hideCursor()

  proc installSignalHandlers() =
    signal(SIGCONT, SIGCONT_handler)
    signal(SIGTSTP, SIGTSTP_handler)

  proc nonblock(enabled: bool) =
    var ttyState: Termios

    # get the terminal state
    discard tcGetAttr(STDIN_FILENO, ttyState.addr)

    if enabled:
      # turn off canonical mode & echo
      ttyState.c_lflag = ttyState.c_lflag and not Cflag(ICANON or ECHO)

      # minimum of number input read
      ttyState.c_cc[VMIN] = 0.cuchar

    else:
      # turn on canonical mode & echo
      ttyState.c_lflag = ttyState.c_lflag or ICANON or ECHO

    # set the terminal attributes.
    discard tcSetAttr(STDIN_FILENO, TCSANOW, ttyState.addr)

  proc kbhit(): cint =
    var tv: Timeval
    tv.tv_sec = Time(0)
    tv.tv_usec = 0

    var fds: TFdSet
    FD_ZERO(fds)
    FD_SET(STDIN_FILENO, fds)
    discard select(STDIN_FILENO+1, fds.addr, nil, nil, tv.addr)
    return FD_ISSET(STDIN_FILENO, fds)

  proc consoleInit() =
    nonblock(true)
    installSignalHandlers()

  proc consoleDeinit() =
    nonblock(false)

  # surely a 100 char buffer is more than enough; the longest
  # keycode sequence I've seen was 6 chars
  const KeySequenceMaxLen = 100

  # global keycode buffer
  var keyBuf {.threadvar.}: array[KeySequenceMaxLen, int]

  const
    keySequences = {
      ord(Key.Up):        @["\eOA", "\e[A"],
      ord(Key.Down):      @["\eOB", "\e[B"],
      ord(Key.Right):     @["\eOC", "\e[C"],
      ord(Key.Left):      @["\eOD", "\e[D"],

      ord(Key.Home):      @["\e[1~", "\e[7~", "\eOH", "\e[H"],
      ord(Key.Insert):    @["\e[2~"],
      ord(Key.Delete):    @["\e[3~"],
      ord(Key.End):       @["\e[4~", "\e[8~", "\eOF", "\e[F"],
      ord(Key.PageUp):    @["\e[5~"],
      ord(Key.PageDown):  @["\e[6~"],

      ord(Key.F1):        @["\e[11~", "\eOP"],
      ord(Key.F2):        @["\e[12~", "\eOQ"],
      ord(Key.F3):        @["\e[13~", "\eOR"],
      ord(Key.F4):        @["\e[14~", "\eOS"],
      ord(Key.F5):        @["\e[15~"],
      ord(Key.F6):        @["\e[17~"],
      ord(Key.F7):        @["\e[18~"],
      ord(Key.F8):        @["\e[19~"],
      ord(Key.F9):        @["\e[20~"],
      ord(Key.F10):       @["\e[21~"],
      ord(Key.F11):       @["\e[23~"],
      ord(Key.F12):       @["\e[24~"],
    }.toTable

  proc splitInputs(inp: openarray[int], max: Natural, mouseInfo: var MouseInfo): seq[seq[int]] =
    ## splits the input buffer to extract mouse coordinates
    var parts: seq[seq[int]] = @[]
    var cur: seq[int] = @[]
    for ch in inp[CSI.len+1 .. max-1]:
      if ch == ord('M'):
        # Button press
        parts.add(cur)
        mouseInfo.action = mbaPressed
        break
      elif ch == ord('m'):
        # Button release
        parts.add(cur)
        mouseInfo.action = mbaReleased
        break
      elif ch != ord(';'):
        cur.add(ch)
      else:
        parts.add(cur)
        cur = @[]
    return parts

  proc getPos(inp: seq[int]): int =
    var str = ""
    for ch in inp:
      str &= $(ch.chr)
    result = parseInt(str)

  proc fillMouseInfo(keyBuf: array[KeySequenceMaxLen, int], mouseInfo: var MouseInfo) =
    let parts = splitInputs(keyBuf, keyBuf.len, mouseInfo)
    mouseInfo.x = parts[1].getPos() - 1
    mouseInfo.y = parts[2].getPos() - 1
    let bitset = parts[0].getPos()
    mouseInfo.ctrl = bitset.testBit(4)
    mouseInfo.shift = bitset.testBit(2)
    mouseInfo.move = bitset.testBit(5)
    case ((bitset.uint8 shl 6) shr 6).int
    of 0: mouseInfo.button = MouseButton.mbLeft
    of 1: mouseInfo.button = MouseButton.mbMiddle
    of 2: mouseInfo.button = MouseButton.mbRight
    else:
      mouseInfo.action = MouseButtonAction.mbaNone
      mouseInfo.button = MouseButton.mbNone # Move sends 3, but we ignore
    mouseInfo.scroll = bitset.testBit(6)
    if mouseInfo.scroll:
      # on scroll button=3 is reported, but we want no button pressed
      mouseInfo.button = MouseButton.mbNone
      if bitset.testBit(0): mouseInfo.scrollDir = ScrollDirection.sdDown
      else: mouseInfo.scrollDir = ScrollDirection.sdUp
    else:
      mouseInfo.scrollDir = ScrollDirection.sdNone

  proc parseKey(charsRead: int, mouseInfo: var MouseInfo): Key =
    # Inspired by
    # https://github.com/mcandre/charm/blob/master/lib/charm.c
    var key = Key.None
    if charsRead == 1:
      let ch = keyBuf[0]
      case ch:
      of   9: key = Key.Tab
      of  10: key = Key.Enter
      of  27: key = Key.Escape
      of  32: key = Key.Space
      of 127: key = Key.Backspace
      of 0, 29, 30, 31: discard   # these have no Windows equivalents so
                                  # we'll ignore them
      else:
        key = toKey(ch)

    elif charsRead > 3 and keyBuf[0] == 27 and keyBuf[1] == 91 and keyBuf[2] == 60: # TODO what are these :)
      fillMouseInfo(keyBuf, mouseInfo)
      return Key.Mouse

    else:
      var inputSeq = ""
      for i in 0..<charsRead:
        inputSeq &= char(keyBuf[i])
      for keyCode, sequences in keySequences.pairs:
        for s in sequences:
          if s == inputSeq:
            key = toKey(keyCode)
    result = key

  proc getKeyAsync(mouseInfo: var MouseInfo): Key =
    var i = 0
    while kbhit() > 0 and i < KeySequenceMaxLen:
      var ret = read(0, keyBuf[i].addr, 1)
      if ret > 0:
        i += 1
      else:
        break
    if i == 0:  # nothing read
      result = Key.None
    else:
      result = parseKey(i, mouseInfo)

  template put(s: string) = stdout.write s

when defined(posix):
  const
    XtermColor    = "xterm-color"
    Xterm256Color = "xterm-256color"

proc enterFullScreen() =
  ## Enters full-screen mode (clears the terminal).
  when defined(posix):
    case getEnv("TERM"):
    of XtermColor:
      stdout.write "\e7\e[?47h"
    of Xterm256Color:
      stdout.write "\e[?1049h"
    else:
      terminal.eraseScreen()
  else:
    terminal.eraseScreen()

proc exitFullScreen() =
  ## Exits full-screen mode (restores the previous contents of the terminal).
  when defined(posix):
    case getEnv("TERM"):
    of XtermColor:
      stdout.write "\e[2J\e[?47l\e8"
    of Xterm256Color:
      stdout.write "\e[?1049l"
    else:
      terminal.eraseScreen()
  else:
    terminal.eraseScreen()
    terminal.setCursorPos(0, 0)

when defined(posix):
  proc enableMouse() =
    stdout.write(MouseTrackAny)
    stdout.flushFile()

  proc disableMouse() =
    stdout.write(DisableMouseTrackAny)
    stdout.flushFile()
else:
  proc enableMouse(hConsoleInput: Handle) =
    var currentMode: DWORD
    discard getConsoleMode(hConsoleInput, currentMode.addr)
    discard setConsoleMode(hConsoleInput,
      ENABLE_WINDOW_INPUT or ENABLE_MOUSE_INPUT or ENABLE_EXTENDED_FLAGS or
      (currentMode and ENABLE_QUICK_EDIT_MODE.bitnot())
    )

  proc disableMouse(hConsoleInput: Handle, oldConsoleMode: DWORD) =
    discard setConsoleMode(hConsoleInput, oldConsoleMode) # TODO: REMOVE MOUSE OPTION ONLY?

proc init*(fullScreen: bool = true) =
  ## Initializes the terminal and enables non-blocking keyboard input. Needs
  ## to be called before doing anything with the library.
  ##
  ## If the module is already intialised, `IllwaveError` is raised.
  if gIllwaveInitialized:
    raise newException(IllwaveError, "Illwave already initialized")
  enterFullScreen()

  consoleInit()
  when defined(posix):
    enableMouse()
  else:
    enableMouse(getStdHandle(STD_INPUT_HANDLE))
  gIllwaveInitialized = true
  terminal.resetAttributes()

proc checkInit() =
  if not gIllwaveInitialized:
    raise newException(IllwaveError, "Illwave not initialized")

proc deinit*() =
  ## Resets the terminal to its previous state. Needs to be called before
  ## exiting the application.
  ##
  ## If the module is not intialised, `IllwaveError` is raised.
  checkInit()
  exitFullScreen()
  when defined(posix):
    disableMouse()
  else:
    disableMouse(getStdHandle(STD_INPUT_HANDLE), gOldConsoleModeInput)
  consoleDeinit()
  gIllwaveInitialized = false
  terminal.resetAttributes()
  terminal.showCursor()

when defined(windows):
  proc fillMouseInfo(inputRecord: INPUT_RECORD, mouseInfo: var MouseInfo) =
    let lastMouseInfo = mouseInfo

    mouseInfo.x = inputRecord.Event.MouseEvent.dwMousePosition.X
    mouseInfo.y = inputRecord.Event.MouseEvent.dwMousePosition.Y

    case inputRecord.Event.MouseEvent.dwButtonState
    of FROM_LEFT_1ST_BUTTON_PRESSED:
      mouseInfo.button = mbLeft
    of FROM_LEFT_2ND_BUTTON_PRESSED:
      mouseInfo.button = mbMiddle
    of RIGHTMOST_BUTTON_PRESSED:
      mouseInfo.button = mbRight
    else:
      mouseInfo.button = mbNone

    if mouseInfo.button != mbNone:
      mouseInfo.action = MouseButtonAction.mbaPressed
    elif mouseInfo.button == mbNone and lastMouseInfo.button != mbNone:
      mouseInfo.action = MouseButtonAction.mbaReleased
    else:
      mouseInfo.action = MouseButtonAction.mbaNone

    if lastMouseInfo.x != mouseInfo.x or lastMouseInfo.y != mouseInfo.y:
      mouseInfo.move = true
    else:
      mouseInfo.move = false

    if bitand(inputRecord.Event.MouseEvent.dwEventFlags, MOUSE_WHEELED) == MOUSE_WHEELED:
      mouseInfo.scroll = true
      if inputRecord.Event.MouseEvent.dwButtonState.testBit(31):
        mouseInfo.scrollDir = ScrollDirection.sdDown
      else:
        mouseInfo.scrollDir = ScrollDirection.sdUp
    else:
      mouseInfo.scroll = false
      mouseInfo.scrollDir = ScrollDirection.sdNone

    mouseInfo.ctrl = bitand(inputRecord.Event.MouseEvent.dwControlKeyState, LEFT_CTRL_PRESSED) == LEFT_CTRL_PRESSED or
        bitand(inputRecord.Event.MouseEvent.dwControlKeyState, RIGHT_CTRL_PRESSED) == RIGHT_CTRL_PRESSED

    mouseInfo.shift = bitand(inputRecord.Event.MouseEvent.dwControlKeyState, SHIFT_PRESSED) == SHIFT_PRESSED


  proc hasMouseInput(mouseInfo: var MouseInfo): bool =
    var buffer: array[INPUT_BUFFER_LEN, INPUT_RECORD]
    var numberOfEventsRead: DWORD
    var toRead: int = 0
    discard peekConsoleInputA(getStdHandle(STD_INPUT_HANDLE), buffer.addr, buffer.len.DWORD, numberOfEventsRead.addr)
    if numberOfEventsRead == 0: return false
    for inputRecord in buffer[0..<numberOfEventsRead.int]:
      toRead.inc()
      if inputRecord.EventType == MOUSE_EVENT: break
    if toRead == 0: return false
    discard readConsoleInput(getStdHandle(STD_INPUT_HANDLE), buffer.addr, toRead.DWORD, numberOfEventsRead.addr)
    if buffer[numberOfEventsRead - 1].EventType == MOUSE_EVENT:
      fillMouseInfo(buffer[numberOfEventsRead - 1], mouseInfo)
      return true
    else:
      return false

proc getKey*(mouseInfo: var MouseInfo): Key =
  ## Reads the next keystroke in a non-blocking manner. If there are no
  ## keypress events in the buffer, `Key.None` is returned.
  ##
  ## If the module is not intialised, `IllwaveError` is raised.
  checkInit()
  when defined(windows):
    result = getKeyAsync()
    if result == Key.None:
      if hasMouseInput(mouseInfo):
        return Key.Mouse
  else:
    result = getKeyAsync(mouseInfo)

proc getKey*(): Key =
  var mouseInfo: MouseInfo
  getKey(mouseInfo)

type
  TerminalChar* = object
    ## Represents a character in the terminal buffer, including color and
    ## style information.
    ##
    ## If `forceWrite` is set to `true`, the character is always output even
    ## when double buffering is enabled (this is a hack to achieve better
    ## continuity of horizontal lines when using UTF-8 box drawing symbols in
    ## the Windows Console).
    ch*: Rune
    fg*: ForegroundColor
    bg*: BackgroundColor
    fgTruecolor*: colors.Color
    bgTruecolor*: colors.Color
    style*: set[terminal.Style]
    forceWrite*: bool
    cursor*: bool

  InternalBuffer = object
    width*: int
    height*: int
    chars*: seq[seq[TerminalChar]]

  TerminalBufferKind* = enum
    Full, Slice,

  TerminalBuffer* = object
    ## A virtual terminal buffer of a fixed width and height. It remembers the
    ## current color and style settings and the current cursor position.
    ##
    ## Write to the terminal buffer with `TerminalBuffer.write()` or access
    ## the character buffer directly with the index operators.
    kind*: TerminalBufferKind
    slice*: ref tuple[x: int, y: int, width: Natural, height: Natural]
    parentSlices*: seq[ref tuple[x: int, y: int, width: Natural, height: Natural]]
    bounds*: tuple[x: int, y: int, width: int, height: int]
    buf*: ref InternalBuffer
    currBg*: BackgroundColor
    currFg*: ForegroundColor
    currFgTruecolor*: colors.Color
    currBgTruecolor*: colors.Color
    currStyle*: set[terminal.Style]
    currAttribs: Attribs

  Attribs = object
    bg: BackgroundColor
    fg: ForegroundColor
    bgTruecolor: colors.Color
    fgTruecolor: colors.Color
    style: set[terminal.Style]

proc `==`*(a, b: colors.Color): bool =
  a.ord == b.ord

proc `==`*(a, b: TerminalBuffer): bool =
  a.buf[] == b.buf[]

proc outOfBounds(tb: TerminalBuffer, x, y: int): bool =
  case tb.kind:
  of Full:
    return x < 0 or y < 0 or y >= tb.buf[].chars.len or x >= tb.buf[].chars[y].len
  of Slice:
    var
      xx = x + tb.slice[].x
      yy = y + tb.slice[].y
    if tb.bounds.y >= 0 and yy < tb.bounds.y:
      return true
    if tb.bounds.x >= 0 and xx < tb.bounds.x:
      return true
    if tb.bounds.height >= 0 and yy >= max(0, tb.bounds.y) + tb.bounds.height:
      return true
    if tb.bounds.width >= 0 and xx >= max(0, tb.bounds.x) + tb.bounds.width:
      return true
  return false

proc grow(tb: var TerminalBuffer, x, y: int) =
  if x >= tb.buf[].width:
    tb.slice[].width = x - tb.slice[].x + 1
    for parentSlice in tb.parentSlices:
      parentSlice[].width = x - parentSlice[].x + 1
    tb.buf[].width = x+1
  if y >= tb.buf[].height:
    tb.slice[].height = y - tb.slice[].y + 1
    for parentSlice in tb.parentSlices:
      parentSlice[].height = y - parentSlice[].y + 1
    tb.buf[].height = y+1
  const space = TerminalChar(ch: " ".toRunes[0])
  while y >= tb.buf[].chars.len:
    tb.buf[].chars.add(sequtils.repeat(space, tb.buf[].width))
  while x >= tb.buf[].chars[y].len:
    tb.buf[].chars[y].add(space)

proc `[]=`*(tb: var TerminalBuffer, x, y: int, ch: TerminalChar) =
  ## Index operator to write a character into the terminal buffer at the
  ## specified location. Does nothing if the location is outside of the
  ## extents of the terminal buffer.
  if outOfBounds(tb, x, y):
    return
  var
    xx = x
    yy = y
  if tb.kind == Slice:
    xx += tb.slice[].x
    yy += tb.slice[].y
  if yy >= 0 and xx >= 0:
    if yy >= tb.buf[].chars.len or xx >= tb.buf[].chars[yy].len:
      grow(tb, xx, yy)
    tb.buf[].chars[yy][xx] = ch

proc `[]`*(tb: TerminalBuffer, x, y: int): TerminalChar =
  ## Index operator to read a character from the terminal buffer at the
  ## specified location. Returns nil if the location is outside of the extents
  ## of the terminal buffer.
  if outOfBounds(tb, x, y):
    return
  var
    xx = x
    yy = y
  if tb.kind == Slice:
    xx += tb.slice[].x
    yy += tb.slice[].y
  if yy >= 0 and xx >= 0 and yy < tb.buf[].chars.len and xx < tb.buf[].chars[yy].len:
    result = tb.buf[].chars[yy][xx]

proc toColor*(r: uint8, g: uint8, b: uint8): colors.Color =
  let rgb: uint =
    r.uint.rotateLeftBits(16) +
    g.uint.rotateLeftBits(8) +
    b.uint
  colors.Color(rgb)

proc fromColor*(color: colors.Color): tuple[r: uint8, g: uint8, b: uint8] =
  let n: uint = cast[uint](color)
  (
    r: n.rotateRightBits(16).uint8,
    g: n.rotateRightBits(8).uint8,
    b: n.uint8,
  )

func x*(tb: TerminalBuffer): int =
  case tb.kind:
  of Full:
    0
  of Slice:
    tb.slice[].x

func y*(tb: TerminalBuffer): int =
  case tb.kind:
  of Full:
    0
  of Slice:
    tb.slice[].y

func width*(tb: TerminalBuffer): Natural =
  ## Returns the width of the terminal buffer.
  case tb.kind:
  of Full:
    if tb.buf != nil:
      tb.buf[].width
    else:
      0
  of Slice:
    tb.slice[].width

func height*(tb: TerminalBuffer): Natural =
  ## Returns the height of the terminal buffer.
  case tb.kind:
  of Full:
    if tb.buf != nil:
      tb.buf[].height
    else:
      0
  of Slice:
    tb.slice[].height

proc fill*(tb: var TerminalBuffer, x1, y1, x2, y2: int, ch: string = " ") =
  ## Fills a rectangular area with the `ch` character using the current text
  ## attributes. The rectangle is clipped to the extends of the terminal
  ## buffer and the call can never fail.
  if x1 < tb.width and y1 < tb.height:
    let
      c = TerminalChar(ch: ch.runeAt(0), fg: tb.currFg, bg: tb.currBg,
                       style: tb.currStyle)

      xe = min(x2, tb.width-1)
      ye = min(y2, tb.height-1)

    for y in y1..ye:
      for x in x1..xe:
        tb[x, y] = c

proc clear*(tb: var TerminalBuffer, ch: string = " ") =
  ## Clears the contents of the terminal buffer with the `ch` character using
  ## the `fgNone` and `bgNone` attributes.
  tb.fill(0, 0, tb.width-1, tb.height-1, ch)

proc initTerminalBuffer(tb: var TerminalBuffer, width, height: Natural) =
  ## Initializes a new terminal buffer object of a fixed `width` and `height`.
  tb.kind = Full
  new tb.slice
  tb.slice[] = (0, 0, width, height)
  tb.bounds = (0, 0, width, height)
  new tb.buf
  tb.buf[].width = width
  tb.buf[].height = height
  newSeq(tb.buf[].chars, height)
  for line in tb.buf[].chars.mitems:
    newSeq(line, width)
  tb.currBg = bgNone
  tb.currFg = fgNone
  tb.currStyle = {}

proc initTerminalBuffer*(width, height: Natural): TerminalBuffer =
  ## Creates a new terminal buffer of a fixed `width` and `height`.
  result.initTerminalBuffer(width, height)
  result.clear()

proc slice*(tb: TerminalBuffer, x, y: int, width, height: Natural, bounds: tuple[x: int, y: int, width: int, height: int]): TerminalBuffer =
  result = tb
  result.kind = Slice
  if bounds.x < 0:
    result.bounds.x = bounds.x
  else:
    result.bounds.x = result.slice[].x + bounds.x
  if bounds.y < 0:
    result.bounds.y = bounds.y
  else:
    result.bounds.y = result.slice[].y + bounds.y
  result.bounds.width = bounds.width
  result.bounds.height = bounds.height
  new result.slice
  result.slice[] = tb.slice[]
  result.slice[].x += x
  result.slice[].y += y
  result.slice[].width = width
  result.slice[].height = height
  result.parentSlices.add(tb.slice)

proc slice*(tb: TerminalBuffer, x, y: int, width, height: Natural): TerminalBuffer =
  result = tb
  result.kind = Slice
  new result.slice
  result.slice[] = tb.slice[]
  result.slice[].x += x
  result.slice[].y += y
  result.slice[].width = width
  result.slice[].height = height
  result.parentSlices.add(tb.slice)

proc contains*(tb: TerminalBuffer, mouse: MouseInfo): bool =
  var
    x = 0
    y = 0
  if tb.kind == Slice:
    x += tb.slice[].x
    y += tb.slice[].y
  mouse.x >= x and
    mouse.x <= x + tb.width - 1 and
    mouse.y >= y and
    mouse.y <= y + tb.height - 1

proc copyFrom*(tb: var TerminalBuffer,
               src: TerminalBuffer, srcX, srcY, width, height: Natural,
               destX, destY: Natural) =
  ## Copies the contents of the `src` terminal buffer into this one.
  ## A rectangular area of dimension `width` and `height` is copied from
  ## the position `srcX` and `srcY` in the source buffer to the position
  ## `destX` and `destY` in this buffer.
  ##
  ## If the extents of the area to be copied lie outside the extents of the
  ## buffers, the copied area will be clipped to the available area (in other
  ## words, the call can never fail; in the worst case it just copies
  ## nothing).
  let
    srcWidth = max(src.width - srcX, 0)
    srcHeight = max(src.height - srcY, 0)
    destWidth = max(tb.width - destX, 0)
    destHeight = max(tb.height - destY, 0)
    w = min(min(srcWidth, destWidth), width)
    h = min(min(srcHeight, destHeight), height)

  for yOffs in 0..<h:
    for xOffs in 0..<w:
      tb[xOffs + destX, yOffs + destY] = src[xOffs + srcX, yOffs + srcY]


proc copyFrom*(tb: var TerminalBuffer, src: TerminalBuffer) =
  ## Copies the full contents of the `src` terminal buffer into this one.
  ##
  ## If the extents of the source buffer is greater than the extents of the
  ## destination buffer, the copied area is clipped to the destination area.
  tb.copyFrom(src, 0, 0, src.width, src.height, 0, 0)

proc setBackgroundColor*(tb: var TerminalBuffer, bg: BackgroundColor) =
  tb.currBg = bg
  tb.currBgTruecolor = colors.Color(0)

proc setBackgroundColor*(tb: var TerminalBuffer, bg: colors.Color) =
  tb.currBgTruecolor = bg
  tb.currBg = bgNone

proc setForegroundColor*(tb: var TerminalBuffer, fg: ForegroundColor) =
  tb.currFg = fg
  tb.currFgTruecolor = colors.Color(0)

proc setForegroundColor*(tb: var TerminalBuffer, fg: colors.Color) =
  tb.currFgTruecolor = fg
  tb.currFg = fgNone

proc setStyle*(tb: var TerminalBuffer, style: set[terminal.Style]) =
  ## Sets the current style flags.
  tb.currStyle = style

func getBackgroundColor*(tb: var TerminalBuffer): BackgroundColor =
  ## Returns the current background color.
  result = tb.currBg

func getForegroundColor*(tb: var TerminalBuffer): ForegroundColor =
  ## Returns the current foreground color.
  result = tb.currFg

func getBackgroundTrueColor*(tb: var TerminalBuffer): colors.Color =
  result = tb.currBgTrueColor

func getForegroundTrueColor*(tb: var TerminalBuffer): colors.Color =
  result = tb.currFgTrueColor

func getStyle*(tb: var TerminalBuffer): set[terminal.Style] =
  ## Returns the current style flags.
  result = tb.currStyle

proc resetAttributes*(tb: var TerminalBuffer) =
  ## Resets the current text attributes to `bgNone`, `fgWhite` and clears
  ## all style flags.
  tb.setBackgroundColor(bgNone)
  tb.setForegroundColor(fgWhite)
  tb.setStyle({})

proc write*(tb: var TerminalBuffer, x, y: int, s: string) =
  ## Writes `s` into the terminal buffer at the specified position using
  ## the current text attributes. Lines do not wrap and attempting to write
  ## outside the extents of the buffer will not raise an error; the output
  ## will be just cropped to the extents of the buffer.
  var currX = x
  for ch in runes(s):
    var c = TerminalChar(ch: ch, fg: tb.currFg, bg: tb.currBg,
                         style: tb.currStyle, fgTruecolor: tb.currFgTruecolor, bgTruecolor: tb.currBgTruecolor)
    tb[currX, y] = c
    inc(currX)

proc setAttribs(c: TerminalChar, attribs: var Attribs) =
  if (c.bgTruecolor.ord == 0 and c.fgTruecolor.ord == 0) and (c.bg == bgNone or c.fg == fgNone or c.style == {}):
    terminal.resetAttributes()
    attribs.bg = c.bg
    attribs.fg = c.fg
    attribs.bgTruecolor = c.bgTruecolor
    attribs.fgTruecolor = c.fgTruecolor
    attribs.style = c.style
    if attribs.bg != bgNone:
      terminal.setBackgroundColor(cast[terminal.BackgroundColor](attribs.bg))
    if attribs.fg != fgNone:
      terminal.setForegroundColor(cast[terminal.ForegroundColor](attribs.fg))
    if attribs.style != {}:
      terminal.setStyle(attribs.style)
  else:
    if c.bgTruecolor.ord != 0:
      if c.bgTruecolor != attribs.bgTruecolor:
        attribs.bgTruecolor = c.bgTruecolor
        attribs.bg = bgNone
        terminal.setBackgroundColor(c.bgTruecolor)
    elif c.bg != attribs.bg:
      attribs.bgTruecolor = colors.Color(0)
      attribs.bg = c.bg
      terminal.setBackgroundColor(cast[terminal.BackgroundColor](attribs.bg))
    if c.fgTruecolor.ord != 0:
      if c.fgTruecolor != attribs.fgTruecolor:
        attribs.fgTruecolor = c.fgTruecolor
        attribs.fg = fgNone
        terminal.setForegroundColor(c.fgTruecolor)
    elif c.fg != attribs.fg:
      attribs.fgTruecolor = colors.Color(0)
      attribs.fg = c.fg
      terminal.setForegroundColor(cast[terminal.ForegroundColor](attribs.fg))
    if c.style != attribs.style:
      attribs.style = c.style
      terminal.setStyle(attribs.style)

proc setPos(x, y: int) =
  terminal.setCursorPos(x, y)

proc setXPos(x: int) =
  terminal.setCursorXPos(x)

proc displayFull(tb: var TerminalBuffer) =
  var buf = ""

  proc flushBuf() =
    if buf.len > 0:
      put buf
      buf = ""

  for y in 0 ..< min(tb.height, terminal.terminalHeight()):
    setPos(0, y)
    for x in 0 ..< min(tb.width, terminal.terminalWidth()):
      let c = tb[x,y]
      if c.bg != tb.currAttribs.bg or c.fg != tb.currAttribs.fg or c.bgTruecolor != tb.currAttribs.bgTruecolor or c.fgTruecolor != tb.currAttribs.fgTruecolor or c.style != tb.currAttribs.style:
        flushBuf()
        setAttribs(c, tb.currAttribs)
      buf &= $c.ch
    flushBuf()


proc displayDiff(tb: var TerminalBuffer, prevTb: TerminalBuffer) =
  var
    buf = ""
    bufXPos, bufYPos: Natural
    currXPos = -1
    currYPos = -1

  proc flushBuf() =
    if buf.len > 0:
      if currYPos != bufYPos:
        currXPos = bufXPos
        currYPos = bufYPos
        setPos(currXPos, currYPos)
      elif currXPos != bufXPos:
        currXPos = bufXPos
        setXPos(currXPos)
      put buf
      inc(currXPos, buf.runeLen)
      buf = ""

  for y in 0 ..< min(tb.height, terminal.terminalHeight()):
    bufXPos = 0
    bufYPos = y
    for x in 0 ..< min(tb.width, terminal.terminalWidth()):
      let c = tb[x,y]
      if c != prevTb[x,y] or c.forceWrite:
        if c.bg != tb.currAttribs.bg or c.fg != tb.currAttribs.fg or c.bgTruecolor != tb.currAttribs.bgTruecolor or c.fgTruecolor != tb.currAttribs.fgTruecolor or c.style != tb.currAttribs.style:
          flushBuf()
          bufXPos = x
          setAttribs(c, tb.currAttribs)
        buf &= $c.ch
      else:
        flushBuf()
        bufXPos = x+1
    flushBuf()


proc display*(tb: var TerminalBuffer) =
  ## Outputs the contents of the terminal buffer to the actual terminal.
  ##
  ## If the module is not intialised, `IllwaveError` is raised.
  checkInit()
  displayFull(tb)
  flushFile(stdout)

proc display*(tb: var TerminalBuffer, prevTb: TerminalBuffer) =
  ## Outputs the contents of the terminal buffer to the actual terminal.
  ##
  ## If the module is not intialised, `IllwaveError` is raised.
  checkInit()
  if tb.width == prevTb.width and
     tb.height == prevTb.height and
     tb.width <= terminal.terminalWidth():
    tb.currAttribs = prevTb.currAttribs
    displayDiff(tb, prevTb)
  else:
    displayFull(tb)
  flushFile(stdout)

type BoxChar = int

const
  LEFT   = 0x01
  RIGHT  = 0x02
  UP     = 0x04
  DOWN   = 0x08
  H_DBL  = 0x10
  V_DBL  = 0x20

  HORIZ = LEFT or RIGHT
  VERT  = UP or DOWN

var gBoxCharsUnicode {.threadvar.}: array[64, string]

gBoxCharsUnicode[0] = " "

gBoxCharsUnicode[   0 or  0 or     0 or    0] = " "
gBoxCharsUnicode[   0 or  0 or     0 or LEFT] = "─"
gBoxCharsUnicode[   0 or  0 or RIGHT or    0] = "─"
gBoxCharsUnicode[   0 or  0 or RIGHT or LEFT] = "─"
gBoxCharsUnicode[   0 or UP or     0 or    0] = "│"
gBoxCharsUnicode[   0 or UP or     0 or LEFT] = "┘"
gBoxCharsUnicode[   0 or UP or RIGHT or    0] = "└"
gBoxCharsUnicode[   0 or UP or RIGHT or LEFT] = "┴"
gBoxCharsUnicode[DOWN or  0 or     0 or    0] = "│"
gBoxCharsUnicode[DOWN or  0 or     0 or LEFT] = "┐"
gBoxCharsUnicode[DOWN or  0 or RIGHT or    0] = "┌"
gBoxCharsUnicode[DOWN or  0 or RIGHT or LEFT] = "┬"
gBoxCharsUnicode[DOWN or UP or     0 or    0] = "│"
gBoxCharsUnicode[DOWN or UP or     0 or LEFT] = "┤"
gBoxCharsUnicode[DOWN or UP or RIGHT or    0] = "├"
gBoxCharsUnicode[DOWN or UP or RIGHT or LEFT] = "┼"

gBoxCharsUnicode[H_DBL or    0 or  0 or     0 or    0] = " "
gBoxCharsUnicode[H_DBL or    0 or  0 or     0 or LEFT] = "═"
gBoxCharsUnicode[H_DBL or    0 or  0 or RIGHT or    0] = "═"
gBoxCharsUnicode[H_DBL or    0 or  0 or RIGHT or LEFT] = "═"
gBoxCharsUnicode[H_DBL or    0 or UP or     0 or    0] = "│"
gBoxCharsUnicode[H_DBL or    0 or UP or     0 or LEFT] = "╛"
gBoxCharsUnicode[H_DBL or    0 or UP or RIGHT or    0] = "╘"
gBoxCharsUnicode[H_DBL or    0 or UP or RIGHT or LEFT] = "╧"
gBoxCharsUnicode[H_DBL or DOWN or  0 or     0 or    0] = "│"
gBoxCharsUnicode[H_DBL or DOWN or  0 or     0 or LEFT] = "╕"
gBoxCharsUnicode[H_DBL or DOWN or  0 or RIGHT or    0] = "╒"
gBoxCharsUnicode[H_DBL or DOWN or  0 or RIGHT or LEFT] = "╤"
gBoxCharsUnicode[H_DBL or DOWN or UP or     0 or    0] = "│"
gBoxCharsUnicode[H_DBL or DOWN or UP or     0 or LEFT] = "╡"
gBoxCharsUnicode[H_DBL or DOWN or UP or RIGHT or    0] = "╞"
gBoxCharsUnicode[H_DBL or DOWN or UP or RIGHT or LEFT] = "╪"

gBoxCharsUnicode[V_DBL or    0 or  0 or     0 or    0] = " "
gBoxCharsUnicode[V_DBL or    0 or  0 or     0 or LEFT] = "─"
gBoxCharsUnicode[V_DBL or    0 or  0 or RIGHT or    0] = "─"
gBoxCharsUnicode[V_DBL or    0 or  0 or RIGHT or LEFT] = "─"
gBoxCharsUnicode[V_DBL or    0 or UP or     0 or    0] = "║"
gBoxCharsUnicode[V_DBL or    0 or UP or     0 or LEFT] = "╜"
gBoxCharsUnicode[V_DBL or    0 or UP or RIGHT or    0] = "╙"
gBoxCharsUnicode[V_DBL or    0 or UP or RIGHT or LEFT] = "╨"
gBoxCharsUnicode[V_DBL or DOWN or  0 or     0 or    0] = "║"
gBoxCharsUnicode[V_DBL or DOWN or  0 or     0 or LEFT] = "╖"
gBoxCharsUnicode[V_DBL or DOWN or  0 or RIGHT or    0] = "╓"
gBoxCharsUnicode[V_DBL or DOWN or  0 or RIGHT or LEFT] = "╥"
gBoxCharsUnicode[V_DBL or DOWN or UP or     0 or    0] = "║"
gBoxCharsUnicode[V_DBL or DOWN or UP or     0 or LEFT] = "╢"
gBoxCharsUnicode[V_DBL or DOWN or UP or RIGHT or    0] = "╟"
gBoxCharsUnicode[V_DBL or DOWN or UP or RIGHT or LEFT] = "╫"

gBoxCharsUnicode[H_DBL or V_DBL or    0 or  0 or     0 or    0] = " "
gBoxCharsUnicode[H_DBL or V_DBL or    0 or  0 or     0 or LEFT] = "═"
gBoxCharsUnicode[H_DBL or V_DBL or    0 or  0 or RIGHT or    0] = "═"
gBoxCharsUnicode[H_DBL or V_DBL or    0 or  0 or RIGHT or LEFT] = "═"
gBoxCharsUnicode[H_DBL or V_DBL or    0 or UP or     0 or    0] = "║"
gBoxCharsUnicode[H_DBL or V_DBL or    0 or UP or     0 or LEFT] = "╝"
gBoxCharsUnicode[H_DBL or V_DBL or    0 or UP or RIGHT or    0] = "╚"
gBoxCharsUnicode[H_DBL or V_DBL or    0 or UP or RIGHT or LEFT] = "╩"
gBoxCharsUnicode[H_DBL or V_DBL or DOWN or  0 or     0 or    0] = "║"
gBoxCharsUnicode[H_DBL or V_DBL or DOWN or  0 or     0 or LEFT] = "╗"
gBoxCharsUnicode[H_DBL or V_DBL or DOWN or  0 or RIGHT or    0] = "╔"
gBoxCharsUnicode[H_DBL or V_DBL or DOWN or  0 or RIGHT or LEFT] = "╦"
gBoxCharsUnicode[H_DBL or V_DBL or DOWN or UP or     0 or    0] = "║"
gBoxCharsUnicode[H_DBL or V_DBL or DOWN or UP or     0 or LEFT] = "╣"
gBoxCharsUnicode[H_DBL or V_DBL or DOWN or UP or RIGHT or    0] = "╠"
gBoxCharsUnicode[H_DBL or V_DBL or DOWN or UP or RIGHT or LEFT] = "╬"

proc toUTF8String(c: BoxChar): string = gBoxCharsUnicode[c]

type BoxBuffer* = object
  ## Box buffers are used to store the results of multiple consecutive box
  ## drawing calls. The idea is that when you draw a series of lines and
  ## rectangles into the buffer, the overlapping lines will get automatically
  ## connected by placing the appropriate UTF-8 symbols at the corner and
  ## junction points. The results can then be written to a terminal buffer.
  width: Natural
  height: Natural
  buf: seq[seq[BoxChar]]

proc initBoxBuffer*(width, height: Natural): BoxBuffer =
  ## Creates a new box buffer of a fixed `width` and `height`.
  result.width = width
  result.height = height
  newSeq(result.buf, height)
  for line in result.buf.mitems:
    newSeq(line, width)

func width*(bb: BoxBuffer): Natural =
  ## Returns the width of the box buffer.
  result = bb.width

func height*(bb: BoxBuffer): Natural =
  ## Returns the height of the box buffer.
  result = bb.height

proc `[]=`(bb: var BoxBuffer, x, y: int, c: BoxChar) =
  if y >= 0 and x >= 0 and y < bb.buf.len and x < bb.buf[y].len:
    bb.buf[y][x] = c

func `[]`(bb: BoxBuffer, x, y: int): BoxChar =
  if y >= 0 and x >= 0 and y < bb.buf.len and x < bb.buf[y].len:
    result = bb.buf[y][x]

proc copyFrom*(bb: var BoxBuffer,
               src: BoxBuffer, srcX, srcY, width, height: Natural,
               destX, destY: Natural) =
  ## Copies the contents of the `src` box buffer into this one.
  ## A rectangular area of dimension `width` and `height` is copied from
  ## the position `srcX` and `srcY` in the source buffer to the position
  ## `destX` and `destY` in this buffer.
  ##
  ## If the extents of the area to be copied lie outside the extents of the
  ## buffers, the copied area will be clipped to the available area (in other
  ## words, the call can never fail; in the worst case it just copies
  ## nothing).
  let
    srcWidth = max(src.width - srcX, 0)
    srcHeight = max(src.height - srcY, 0)
    destWidth = max(bb.width - destX, 0)
    destHeight = max(bb.height - destY, 0)
    w = min(min(srcWidth, destWidth), width)
    h = min(min(srcHeight, destHeight), height)

  for yOffs in 0..<h:
    for xOffs in 0..<w:
      bb[xOffs + destX, yOffs + destY] = src[xOffs + srcX, yOffs + srcY]


proc copyFrom*(bb: var BoxBuffer, src: BoxBuffer) =
  ## Copies the full contents of the `src` box buffer into this one.
  ##
  ## If the extents of the source buffer is greater than the extents of the
  ## destination buffer, the copied area is clipped to the destination area.
  bb.copyFrom(src, 0, 0, src.width, src.height, 0, 0)

proc drawHorizLine*(bb: var BoxBuffer, x1, x2, y: int,
                    doubleStyle: bool = false, connect: bool = true) =
  ## Draws a horizontal line into the box buffer. Set `doubleStyle` to `true`
  ## to draw double lines. Set `connect` to `true` to connect overlapping
  ## lines.
  if y >= bb.height: return
  var xStart = x1
  var xEnd = x2
  if xStart > xEnd: swap(xStart, xEnd)
  if xStart >= bb.width: return

  xEnd = min(xEnd, bb.width-1)
  if connect:
    for x in xStart..xEnd:
      var c = bb[x,y]
      var h: int
      if x == xStart:
        h = if (c and LEFT) > 0: HORIZ else: RIGHT
      elif x == xEnd:
        h = if (c and RIGHT) > 0: HORIZ else: LEFT
      else:
        h = HORIZ
      if doubleStyle: h = h or H_DBL
      bb[x,y] = c or h
  else:
    for x in xStart..xEnd:
      var h = HORIZ
      if doubleStyle: h = h or H_DBL
      bb[x,y] = h


proc drawVertLine*(bb: var BoxBuffer, x, y1, y2: int,
                   doubleStyle: bool = false, connect: bool = true) =
  ## Draws a vertical line into the box buffer. Set `doubleStyle` to `true` to
  ## draw double lines. Set `connect` to `true` to connect overlapping lines.
  if x >= bb.width: return
  var yStart = y1
  var yEnd = y2
  if yStart > yEnd: swap(yStart, yEnd)
  if yStart >= bb.height: return

  yEnd = min(yEnd, bb.height-1)
  if connect:
    for y in yStart..yEnd:
      var c = bb[x,y]
      var v: int
      if y == yStart:
        v = if (c and UP) > 0: VERT else: DOWN
      elif y == yEnd:
        v = if (c and DOWN) > 0: VERT else: UP
      else:
        v = VERT
      if doubleStyle: v = v or V_DBL
      bb[x,y] = c or v
  else:
    for y in yStart..yEnd:
      var v = VERT
      if doubleStyle: v = v or V_DBL
      bb[x,y] = v


proc drawRect*(bb: var BoxBuffer, x1, y1, x2, y2: int,
               doubleStyle: bool = false, connect: bool = true) =
  ## Draws a rectangle into the box buffer. Set `doubleStyle` to `true` to
  ## draw double lines. Set `connect` to `true` to connect overlapping lines.
  if abs(x1-x2) < 1 or abs(y1-y2) < 1: return

  if connect:
    bb.drawHorizLine(x1, x2, y1, doubleStyle)
    bb.drawHorizLine(x1, x2, y2, doubleStyle)
    bb.drawVertLine(x1, y1, y2, doubleStyle)
    bb.drawVertLine(x2, y1, y2, doubleStyle)
  else:
    bb.drawHorizLine(x1+1, x2-1, y1, doubleStyle, connect = false)
    bb.drawHorizLine(x1+1, x2-1, y2, doubleStyle, connect = false)
    bb.drawVertLine(x1, y1+1, y2-1, doubleStyle, connect = false)
    bb.drawVertLine(x2, y1+1, y2-1, doubleStyle, connect = false)

    var c = RIGHT or DOWN
    if doubleStyle: c = c or V_DBL or H_DBL
    bb[x1,y1] = c

    c = LEFT or DOWN
    if doubleStyle: c = c or V_DBL or H_DBL
    bb[x2,y1] = c

    c = RIGHT or UP
    if doubleStyle: c = c or V_DBL or H_DBL
    bb[x1,y2] = c

    c = LEFT or UP
    if doubleStyle: c = c or V_DBL or H_DBL
    bb[x2,y2] = c


proc write*(tb: var TerminalBuffer, bb: var BoxBuffer) =
  ## Writes the contents of the box buffer into this terminal buffer with
  ## the current text attributes.
  var horizBoxCharCount: int
  var forceWrite: bool

  for y in 0..<bb.height:
    horizBoxCharCount = 0
    forceWrite = false
    for x in 0..<bb.width:
      let boxChar = bb[x,y]
      if boxChar > 0:
        if ((boxChar and LEFT) or (boxChar and RIGHT)) > 0:
          if horizBoxCharCount == 1:
            var prev = tb[x-1,y]
            prev.forceWrite = true
            tb[x-1,y] = prev
          if horizBoxCharCount >= 1:
            forceWrite = true
          inc(horizBoxCharCount)
        else:
          horizBoxCharCount = 0
          forceWrite = false

        var c = TerminalChar(ch: toUTF8String(boxChar).runeAt(0),
                             fg: tb.currFg, bg: tb.currBg,
                             style: tb.currStyle, forceWrite: forceWrite,
                             fgTruecolor: tb.currFgTruecolor, bgTruecolor: tb.currBgTruecolor)
        tb[x,y] = c


type
  TerminalCmd* = enum  ## commands that can be expressed as arguments
    resetStyle         ## reset attributes

template writeProcessArg(tb: var TerminalBuffer, s: string) =
  tb.write(s)

template writeProcessArg(tb: var TerminalBuffer, style: terminal.Style) =
  tb.setStyle({style})

template writeProcessArg(tb: var TerminalBuffer, style: set[terminal.Style]) =
  tb.setStyle(style)

template writeProcessArg(tb: var TerminalBuffer, color: ForegroundColor) =
  tb.setForegroundColor(color)

template writeProcessArg(tb: var TerminalBuffer, color: BackgroundColor) =
  tb.setBackgroundColor(color)

template writeProcessArg(tb: var TerminalBuffer, cmd: TerminalCmd) =
  when cmd == resetStyle:
    tb.resetAttributes()

proc grow(tb: TerminalBuffer, bb: var BoxBuffer, x, y: int) =
  if outOfBounds(tb, x, y):
    return
  if x >= bb.width:
    bb.width = x+1
  if y >= bb.height:
    bb.height = y+1
  const ch = BoxChar(0)
  while y >= bb.buf.len:
    bb.buf.add(sequtils.repeat(ch, bb.width))
  while x >= bb.buf[y].len:
    bb.buf[y].add(ch)

proc drawHorizLine*(tb: var TerminalBuffer, x1, x2, y: int,
                    doubleStyle: bool = false) =
  ## Convenience method to draw a single horizontal line into a terminal
  ## buffer directly.
  var bb = initBoxBuffer(tb.width, tb.height)
  grow(tb, bb, max(x1, x2), y)
  bb.drawHorizLine(x1, x2, y, doubleStyle)
  tb.write(bb)

proc drawVertLine*(tb: var TerminalBuffer, x, y1, y2: int,
                   doubleStyle: bool = false) =
  ## Convenience method to draw a single vertical line into a terminal buffer
  ## directly.
  var bb = initBoxBuffer(tb.width, tb.height)
  grow(tb, bb, x, max(y1, y2))
  bb.drawVertLine(x, y1, y2, doubleStyle)
  tb.write(bb)

proc drawRect*(tb: var TerminalBuffer, x1, y1, x2, y2: int,
               doubleStyle: bool = false) =
  ## Convenience method to draw a rectangle into a terminal buffer directly.
  var bb = initBoxBuffer(tb.width, tb.height)
  grow(tb, bb, max(x1, x2), max(y1, y2))
  bb.drawRect(x1, y1, x2, y2, doubleStyle)
  tb.write(bb)
