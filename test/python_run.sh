#!/usr/bin/env python3

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk

class CommandList(Gtk.Window):

    def __init__(self):
        Gtk.Window.__init__(self, title="指令")
        self.set_default_size(400, 600)

        liststore = Gtk.ListStore(str, str)
        liststore.append(["list", "添加源"])
        liststore.append(["software", "安装开发人员需要的软件包"])
        liststore.append(["clone", "克隆项目"])
        liststore.append(["make", "debug编译后安装源码"])
        liststore.append(["cmake", "只进行debug编译"])

        treeview = Gtk.TreeView(model=liststore)

        command_column = Gtk.TreeViewColumn("常用开发指令", Gtk.CellRendererText(), text=0)
        description_column = Gtk.TreeViewColumn("描述", Gtk.CellRendererText(), text=1)

        treeview.append_column(command_column)
        treeview.append_column(description_column)

        treeview.connect("row-activated", self.on_row_activated)

        self.add(treeview)

    def on_row_activated(self, treeview, path, column):
        model = treeview.get_model()
        iter = model.get_iter(path)
        command = model.get_value(iter, 0)
        description = model.get_value(iter, 1)

        self.execute_command(command)

    def execute_command(self, command):
        # 根据选中的指令执行相应的操作
        if command == "list":
            self.show_popup_message("执行添加源的操作")
            # 在这里添加执行"list"指令的操作
        elif command == "software":
            self.show_popup_message("执行安装软件包的操作")
            # 在这里添加执行"software"指令的操作
        elif command == "clone":
            self.show_popup_message("执行克隆项目的操作")
            # 在这里添加执行"clone"指令的操作
        elif command == "make":
            self.show_popup_message("执行编译并安装源码的操作")
            # 在这里添加执行"make"指令的操作
        elif command == "cmake":
            self.show_popup_message("执行只进行debug编译的操作")
            # 在这里添加执行"cmake"指令的操作

    def show_popup_message(self, message):
        dialog = Gtk.MessageDialog(self, 0, Gtk.MessageType.INFO,
                                   Gtk.ButtonsType.OK, "选中的指令")
        dialog.format_secondary_text(message)
        dialog.run()
        dialog.destroy()

win = CommandList()
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()