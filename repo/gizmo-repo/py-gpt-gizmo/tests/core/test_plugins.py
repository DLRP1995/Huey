#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ================================================== #
# This file is a part of PYGPT package               #
# Website: https://pygpt.net                         #
# GitHub:  https://github.com/szczyglis-dev/py-gpt   #
# MIT License                                        #
# Created By  : Marcin Szczygliński                  #
# Updated Date: 2023.12.22 02:00:00                  #
# ================================================== #

import pytest
from unittest.mock import MagicMock

import requests
from PySide6.QtWidgets import QMainWindow

from pygpt_net.core.config import Config
from pygpt_net.core.plugins import Plugins
from pygpt_net.core.plugin.base_plugin import BasePlugin


@pytest.fixture
def mock_window():
    window = MagicMock(spec=QMainWindow)
    window.config = MagicMock(spec=Config)
    window.config.path = 'test'
    return window


def mock_get(key):
    if key == "img_prompt":
        return 'test'
    elif key == "img_raw":
        return True


def mock_has(key):
    """
    Mock has
    """
    if key == "img_prompt":
        return True


def test_is_registered(mock_window):
    """
    Test is registered
    """
    plugins = Plugins(mock_window)
    plugins.window.config.get = mock_get
    plugins.window.config.has = mock_has
    plugin = BasePlugin()
    plugin.id = 'test'
    plugins.register(plugin)

    assert plugins.is_registered('test') is True


def test_register(mock_window):
    """
    Test register
    """
    plugins = Plugins(mock_window)
    plugins.window.config.get = mock_get
    plugins.window.config.has = mock_has
    plugin = BasePlugin()
    plugin.id = 'test'
    plugins.register(plugin)

    assert plugins.plugins['test'] == plugin


def test_restore_options(mock_window):
    """
    Test restore options
    """
    plugins = Plugins(mock_window)
    plugins.window.config.get = mock_get
    plugins.window.config.has = mock_has
    plugin = BasePlugin()
    plugin.id = 'test'
    plugins.register(plugin)
    plugins.plugins['test'].options = {'test': {'value': 'test'}}
    plugins.restore_options('test')
    assert plugins.plugins['test'].options == plugin.options
