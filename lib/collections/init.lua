local collections = {}

local Deque = require("collections.deque")
collections.Deque = Deque

local OrderedDict = require("collections.ordered_dict")
collections.OrderedDict = OrderedDict

local PriorityQueue = require("collections.priority_queue")
collections.PriorityQueue = PriorityQueue

return collections
