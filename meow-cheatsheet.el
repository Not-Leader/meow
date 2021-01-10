;;; meow-cheatsheet.el --- Cheatsheet for Meow
;;; -*- lexical-binding: t -*-

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;; Cheatsheet for Meow.

;;; Code:

(require 'dash)
(require 's)

(require 'meow-var)
(require 'meow-util)

(defconst meow--cheatsheet-note
  (format "
NOTE:
%s means this command will expand current region.
" (propertize "ex" 'face 'meow-cheatsheet-highlight)))

(defconst meow-cheatsheet-layout-qwerty
  "
                                                           Meow Cheatsheet For Qwerty
┏━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━━━━━┓
┃       ~ │       ! │       @ │       # │       $ │       % │       ^ │       & │       * │       ( │       ) │       _ │       + │         DEL ┃
┃      [~]|      [!]|      [@]|      [#]|      [$]|      [%]|      [^]|      [&]|      [*]|      [(]|      [)]|      [_]|      [+]|             ┃
┠─┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┤             ┃
┃       ` │       1 │       2 │       3 │       4 │       5 │       6 │       7 │       8 │       9 │       0 │       - │       = │             ┃
┃      [`]|      [1]|      [2]|      [3]|      [4]|      [5]|      [6]|      [7]|      [8]|      [9]|      [0]|      [-]|      [=]|             ┃
┠─────────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────────┨
┃         TAB │       Q │       W │       E │       R │       T │       Y │       U │       I │       O │       P │       { │       } │       | ┃
┃             |      [Q]|      [W]|      [E]|      [R]|      [T]|      [Y]|      [U]|      [I]|      [O]|      [P]|      [{]|      [}]|      [|]┃
┃             ├┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┨
┃             │       q │       w │       e │       r │       t │       y │       u │       i │       o │       p │       [ │       ] │       \\ ┃
┃             |      [q]|      [w]|      [e]|      [r]|      [t]|      [y]|      [u]|      [i]|      [o]|      [p]|      [[]|      []]|      [\\]┃
┠─────────────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─────────┨
┃               │       A │       S │       D │       F │       G │       H │       J │       K │       L │       : │       \" │             RET ┃
┃               |      [A]|      [S]|      [D]|      [F]|      [G]|      [H]|      [J]|      [K]|      [L]|      [:]|      [\"]│                 ┃
┃               ├┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┤                 ┃
┃               │       a │       s │       d │       f │       g │       h │       j │       k │       l │       ; │       ' │                 ┃
┃               |      [a]|      [s]|      [d]|      [f]|      [g]|      [h]|      [j]|      [k]|      [l]|      [;]|      [']|                 ┃
┠───────────────┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────────────────┨
┃                     │       Z │       X │       C │       V │       B │       N │       M │       < │       > │       ? │                     ┃
┃                     |      [Z]|      [X]|      [C]|      [V]|      [B]|      [N]|      [M]|      [<]|      [>]|      [?]|                     ┃
┃                     ├┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┤                     ┃
┃                     │       z │       x │       c │       v │       b │       n │       m │       , │       . │       / │                     ┃
┃                     |      [z]|      [x]|      [c]|      [v]|      [b]|      [n]|      [m]|      [,]|      [.]|      [/]|                     ┃
┗━━━━━━━━━━━━━━━━━━━━━┷━━━━━━━━━┷━━━━━━━━━┷━━━━━━━━━╅─────────┴─────────┴─────────┴─────────╆━━━━━━━━━┷━━━━━━━━━┷━━━━━━━━━┷━━━━━━━━━━━━━━━━━━━━━┛
                                                    ┃                                   SPC ┃
                                                    ┃                                       ┃
                                                    ┃                                       ┃
                                                    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
" )


(defconst meow-cheatsheet-layout-dvp
  "
                                                      Meow Cheatsheet For Programmer Dvorak

┏━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━━━━━┓
┃       ~ │       % │       7 │       5 │       3 │       1 │       9 │       0 │       2 │       4 │       6 │       8 │       ` │         DEL ┃
┃      [~]│      [%]│      [7]│      [5]│      [3]│      [1]│      [9]│      [0]│      [2]│      [4]│      [6]│      [8]│      [`]│             ┃
┠─┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┤             ┃
┃       $ │       & │       [ │       { │       } │       ( │       = │       * │       ) │       + │       ] │       ! │       # │             ┃
┃      [$]│      [&]│      [[]│      [{]│      [}]│      [(]│      [=]│      [*]│      [)]│      [+]│      []]│      [!]│      [#]│             ┃
┠─────────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────────┨
┃         TAB │       : │       < │       > │       P │       Y │       F │       G │       C │       R │       L │       ? │       ^ │       | ┃
┃             │      [:]│      [<]│      [>]│      [P]│      [Y]│      [F]│      [G]│      [C]│      [R]│      [L]│      [?]│      [^]│      [|]┃
┃             ├┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┨
┃             │       ; │       , │       . │       p │       y │       f │       g │       c │       r │       l │       / │       @ │       \\ ┃
┃             │      [;]│      [,]│      [.]│      [p]│      [y]│      [f]│      [g]│      [c]│      [r]│      [l]│      [/]│      [@]│      [\\]┃
┠─────────────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─────────┨
┃               │       A │       O │       E │       U │       I │       D │       H │       T │       N │       S │       _ │             RET ┃
┃               │      [A]│      [O]│      [E]│      [U]│      [I]│      [D]│      [H]│      [T]│      [N]│      [S]│      [_]│                 ┃
┃               ├┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┤                 ┃
┃               │       a │       o │       e │       u │       i │       d │       h │       t │       n │       s │       - │                 ┃
┃               │      [a]│      [o]│      [e]│      [u]│      [i]│      [d]│      [h]│      [t]│      [n]│      [s]│      [-]│                 ┃
┠───────────────┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────────────────┨
┃                     │       \" │       Q │       J │       K │       X │       B │       M │       W │       V │       Z │                     ┃
┃                     │      [\"]│      [Q]│      [J]│      [K]│      [X]│      [B]│      [M]│      [W]│      [V]│      [Z]│                     ┃
┃                     ├┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┤                     ┃
┃                     │       ' │       q │       j │       k │       x │       b │       m │       w │       v │       z │                     ┃
┃                     │      [']│      [q]│      [j]│      [k]│      [x]│      [b]│      [m]│      [w]│      [v]│      [z]│                     ┃
┗━━━━━━━━━━━━━━━━━━━━━┷━━━━━━━━━┷━━━━━━━━━┷━━━━━━━━━╅─────────┴─────────┴─────────┴─────────╆━━━━━━━━━┷━━━━━━━━━┷━━━━━━━━━┷━━━━━━━━━━━━━━━━━━━━━┛
                                                    ┃                                   SPC ┃
                                                    ┃                                       ┃
                                                    ┃                                       ┃
                                                    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
")

(defconst meow-cheatsheet-layout-dvorak
  "
                                                      Meow Cheatsheet For Dvorak Simplified

┏━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━━━━━┓
┃       ~ │       ! │       @ │       # │       $ │       % │       ^ │       & │       * │       ( │       ) │       { │       } │         DEL ┃
┃      [~]|      [!]|      [@]|      [#]|      [$]|      [%]|      [^]|      [&]|      [*]|      [(]|      [)]|      [{]|      [}]|             ┃
┠─┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┤             ┃
┃       ` │       1 │       2 │       3 │       4 │       5 │       6 │       7 │       8 │       9 │       0 │       [ │       ] │             ┃
┃      [`]|      [1]|      [2]|      [3]|      [4]|      [5]|      [6]|      [7]|      [8]|      [9]|      [0]|      [[]|      []]|             ┃
┠─────────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────────┨
┃         TAB │       \" │       < │       > │       P │       Y │       F │       G │       C │       R │       L │       ? │       + │       | ┃
┃             │      [\"]│      [<]│      [>]│      [P]│      [Y]│      [F]│      [G]│      [C]│      [R]│      [L]│      [?]│      [+]│      [|]┃
┃             ├┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┨
┃             │       ' │       , │       . │       p │       y │       f │       g │       c │       r │       l │       / │       = │       \\ ┃
┃             │      [']│      [,]│      [.]│      [p]│      [y]│      [f]│      [g]│      [c]│      [r]│      [l]│      [/]│      [=]│      [\\]┃
┠─────────────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─────────┨
┃               │       A │       O │       E │       U │       I │       D │       H │       T │       N │       S │       _ │             RET ┃
┃               │      [A]│      [O]│      [E]│      [U]│      [I]│      [D]│      [H]│      [T]│      [N]│      [S]│      [_]│                 ┃
┃               ├┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┤                 ┃
┃               │       a │       o │       e │       u │       i │       d │       h │       t │       n │       s │       - │                 ┃
┃               │      [a]│      [o]│      [e]│      [u]│      [i]│      [d]│      [h]│      [t]│      [n]│      [s]│      [-]│                 ┃
┠───────────────┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────────────────┨
┃                     │       : │       Q │       J │       K │       X │       B │       M │       W │       V │       Z │                     ┃
┃                     │      [:]│      [Q]│      [J]│      [K]│      [X]│      [B]│      [M]│      [W]│      [V]│      [Z]│                     ┃
┃                     ├┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┤                     ┃
┃                     │       ; │       q │       j │       k │       x │       b │       m │       w │       v │       z │                     ┃
┃                     │      [;]│      [q]│      [j]│      [k]│      [x]│      [b]│      [m]│      [w]│      [v]│      [z]│                     ┃
┗━━━━━━━━━━━━━━━━━━━━━┷━━━━━━━━━┷━━━━━━━━━┷━━━━━━━━━╅─────────┴─────────┴─────────┴─────────╆━━━━━━━━━┷━━━━━━━━━┷━━━━━━━━━┷━━━━━━━━━━━━━━━━━━━━━┛
                                                    ┃                                   SPC ┃
                                                    ┃                                       ┃
                                                    ┃                                       ┃
                                                    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
")

(defconst meow-cheatsheet-layout-colemak
  "
                                                           Meow Cheatsheet For Colemak
┏━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━┯━━━━━━━━━━━━━┓
┃       ~ │       ! │       @ │       # │       $ │       % │       ^ │       & │       * │       ( │       ) │       _ │       + │         DEL ┃
┃      [~]|      [!]|      [@]|      [#]|      [$]|      [%]|      [^]|      [&]|      [*]|      [(]|      [)]|      [_]|      [+]|             ┃
┠─┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┤             ┃
┃       ` │       1 │       2 │       3 │       4 │       5 │       6 │       7 │       8 │       9 │       0 │       - │       = │             ┃
┃      [`]|      [1]|      [2]|      [3]|      [4]|      [5]|      [6]|      [7]|      [8]|      [9]|      [0]|      [-]|      [=]|             ┃
┠─────────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────┴───┬─────────┨
┃         TAB │       Q │       W │       F │       P │       G │       J │       L │       U │       Y │       : │       { │       } │       | ┃
┃             |      [Q]|      [W]|      [F]|      [P]|      [G]|      [J]|      [L]|      [U]|      [Y]|      [:]|      [{]|      [}]|      [|]┃
┃             ├┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┨
┃             │       q │       w │       f │       p │       g │       j │       l │       u │       y │       ; │       [ │       ] │       \\ ┃
┃             |      [q]|      [w]|      [f]|      [p]|      [g]|      [j]|      [l]|      [u]|      [y]|      [;]|      [[]|      []]|      [\\]┃
┠─────────────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─┬───────┴─────────┨
┃               │       A │       R │       S │       T │       D │       H │       N │       E │       I │       O │       \" │             RET ┃
┃               |      [A]|      [R]|      [S]|      [T]|      [D]|      [H]|      [N]|      [E]|      [I]|      [O]|      [\"]│                 ┃
┃               ├┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┤                 ┃
┃               │       a │       r │       s │       t │       d │       h │       n │       e │       i │       o │       ' │                 ┃
┃               |      [a]|      [r]|      [s]|      [t]|      [d]|      [h]|      [n]|      [e]|      [i]|      [o]|      [']|                 ┃
┠───────────────┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────┬───┴─────────────────┨
┃                     │       Z │       X │       C │       V │       B │       K │       M │       < │       > │       ? │                     ┃
┃                     |      [Z]|      [X]|      [C]|      [V]|      [B]|      [K]|      [M]|      [<]|      [>]|      [?]|                     ┃
┃                     ├┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┼┄┄┄┄┄┄┄┄┄┤                     ┃
┃                     │       z │       x │       c │       v │       b │       k │       m │       , │       . │       / │                     ┃
┃                     |      [z]|      [x]|      [c]|      [v]|      [b]|      [k]|      [m]|      [,]|      [.]|      [/]|                     ┃
┗━━━━━━━━━━━━━━━━━━━━━┷━━━━━━━━━┷━━━━━━━━━┷━━━━━━━━━╅─────────┴─────────┴─────────┴─────────╆━━━━━━━━━┷━━━━━━━━━┷━━━━━━━━━┷━━━━━━━━━━━━━━━━━━━━━┛
                                                    ┃                                   SPC ┃
                                                    ┃                                       ┃
                                                    ┃                                       ┃
                                                    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
" )

(defun meow--render-cheatshet-thing-table ()
  (concat
   (format
    "%s, %s, %s and %s require a %s as input:\n"
    (propertize "inner" 'face 'meow-cheatsheet-highlight)
    (propertize "bounds" 'face 'meow-cheatsheet-highlight)
    (propertize "begin" 'face 'meow-cheatsheet-highlight)
    (propertize "end" 'face 'meow-cheatsheet-highlight)
    (propertize "THING" 'face 'meow-cheatsheet-highlight))
   (meow--cheatsheet-render-char-thing-table 'meow-cheatsheet-highlight)))

(defvar meow-cheatsheet-layout nil
  "Keyboard layout used to display cheatsheet.

Currently `meow-cheatsheet-layout-qwerty', `meow-cheatsheet-layout-dvorak',
`meow-cheatsheet-layout-dvp' and `meow-cheatsheet-layout-colemak' is supperted.")

(defconst meow--cheatsheet-keys
  '("a" "A" "b" "B" "c" "C" "d" "D" "e" "E" "f" "F" "g" "G" "h" "H" "i" "I" "j" "J" "k" "K" "l" "L" "m" "M" "n" "N" "o" "O" "p" "P" "q" "Q" "r" "R" "s" "S" "t" "T" "u" "U" "v" "V" "w" "W" "x" "X" "y" "Y" "z" "Z" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "!" "@" "" "$" "%" "^" "&" "*" "" "~" "-" "_" "=" "+" "," "<" "." ">" "/" "?" "(" ")" "[" "]" "{" "}" "\\" "|" ";" ":" "'" "\"" "#" "`"))

(defun meow--short-command-name (cmd k)
  (if-let ((s
            (or (alist-get cmd meow-command-to-short-name-list)
                (cl-case cmd
                  (undefined "")
                  (t (->> (symbol-name cmd)
                          (s-replace "meow-" "" )))))))
      (if (<= (length s) 9)
          (format "% 9s" s)
        (s-truncate 9 s "…"))))

(defun meow--fill-cheatsheet (cheatsheet)
  (-reduce-from (lambda (cs k)
                  (let ((cmd (key-binding (read-kbd-macro k))))
                    (if (and cmd (symbolp cmd))
                        (let ((case-fold-search nil))
                          (s-replace (format "      [%s]" k)
                                     (propertize (meow--short-command-name cmd k) 'face 'meow-cheatsheet-command)
                                     cs))
                      cs)))
                cheatsheet
                meow--cheatsheet-keys))

(defun meow--cheatsheet-render-char-thing-table (&optional key-face)
  (let* ((ww (frame-width))
         (w 16)
         (col (min 5 (/ ww w))))
    (->> (-map-indexed
          (-lambda (idx (c . th))
            (format "% 9s ->% 3s%s"
                    (symbol-name th)
                    (propertize (char-to-string c) 'face (or key-face 'font-lock-keyword-face))
                    (if (= (1- col) (mod idx col))
                        "\n"
                      " ")))
          meow-char-thing-table)
         (s-join "")
         (s-trim-right))))

(defun meow--show-cheatsheet (cheatsheet)
  (let ((buf (get-buffer-create (format "*Meow Cheatsheet"))))
    (with-current-buffer buf
      (setq buffer-read-only nil)
      (erase-buffer)
      (insert cheatsheet)
      (insert meow--cheatsheet-note)
      (insert (meow--render-cheatshet-thing-table))
      (text-mode)
      (setq buffer-read-only t))
    (switch-to-buffer buf)))

(defun meow-cheatsheet ()
  (interactive)
  (if (not meow-cheatsheet-layout)
      (message "Please specify `meow-cheatsheet-layout'!")
    (let ((raw-cheatsheet meow-cheatsheet-layout))
      (-> raw-cheatsheet
          (propertize 'face 'meow-cheatsheet)
          meow--fill-cheatsheet
          (meow--show-cheatsheet)))))

(provide 'meow-cheatsheet)
;;; meow-cheatsheet.el ends here
