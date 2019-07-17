--------------------------------------------------------------------------------
-- @File:   date_time.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- ...
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-17 14:41:55
-- @Changes: 
--      - remove color as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-02 10:23:31
-- @Changes: 
--      - newly written
--      - ...
--------------------------------------------------------------------------------
-- [ modules imports ] ---------------------------------------------------------
local os = os

local lain = require("lain")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi
local markup = lain.util.markup

local util = require("themes.ayu.util")

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ function definitions ] ----------------------------------------------------
os.setlocale(os.getenv("LANG")) -- to localize the clock
module.gen_wibar_widget = function()
    local clock_icon = util.fa_ico(beautiful.widget_colors.cal, '')
    local clock_widget = wibox.widget.textclock(
                             markup(beautiful.widget_colors.cal, "%A %d %B") ..
                                 markup(beautiful.fg_normal, " | ") ..
                                 markup(beautiful.widget_colors.clock, "%H:%M"))
    clock_widget.font = beautiful.font
    local clock_wibox_widget = util.create_wibar_widget(
                                   beautiful.widget_colors.cal, clock_icon,
                                   clock_widget)

    -- popup calendar
    beautiful.cal = lain.widget.cal{
        attach_to = {clock_wibox_widget},
        notification_preset = {
            font = beautiful.font_name .. dpi(10),
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal
        }
    }

    return clock_wibox_widget
end

module.gen_desktop_widget = function()
    local gen_deskop_clock_box = function()
        local deskop_clock = wibox.widget.textclock(
                                 markup.fontfg(beautiful.font_name .. dpi(38),
                                               beautiful.bg_normal, " %H:%M "))
        deskop_clock.align = 'center'
        return util.create_boxed_widget(deskop_clock, 4*dpi(38),
                                        beautiful.widget_colors.desktop_clock)
    end

    local gen_desktop_clock_date = function()
        return wibox.widget.textclock(markup.fontfg(
                                          beautiful.font_name .. dpi(14),
                                          beautiful.fg_normal, "Today is ") ..
                                          markup.fontfg(
                                              beautiful.font_name .. dpi(14),
                                              beautiful.widget_colors
                                                  .desktop_day, "%A") ..
                                          markup.fontfg(
                                              beautiful.font_name .. dpi(14),
                                              beautiful.fg_normal, ", the ") ..
                                          markup.fontfg(
                                              beautiful.font_name .. dpi(14),
                                              beautiful.widget_colors
                                                  .desktop_date, "%d.") ..
                                          markup.fontfg(
                                              beautiful.font_name .. dpi(14),
                                              beautiful.fg_normal, " of ") ..
                                          markup.fontfg(
                                              beautiful.font_name .. dpi(14),
                                              beautiful.widget_colors
                                                  .desktop_month, "%B") ..
                                          markup.fontfg(
                                              beautiful.font_name .. dpi(14),
                                              beautiful.fg_normal, "."))
    end

    return wibox.widget{
        nil,
        {

            {
                nil,
                gen_deskop_clock_box(),
                nil,
                expand = "none",
                layout = wibox.layout.align.horizontal
            },
            gen_desktop_clock_date(),
            layout = wibox.layout.fixed.vertical
        },
        expand = 'outside',
        nil,
        layout = wibox.layout.align.horizontal
    }
end

-- [ return module objects ] ---------------------------------------------------
return module