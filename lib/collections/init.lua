local collections = {}

local Deque = require("collections.deque")
collections.Deque = Deque

local ODict = require("collections.odict")
collections.ODict = ODict

local PriorityQueue = require("collections.priority_queue")
collections.PriorityQueue = PriorityQueue

return collections
