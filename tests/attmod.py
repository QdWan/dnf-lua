class RangedDictionary(dict):
    """..."""

    def __getitem__(self, key):
        """..."""
        for rng in self.keys():
            if key == rng:
                return super().__getitem__(key)
            if key in rng:
                return super().__getitem__(rng)
        return super().__getitem__(key)

class AttributeModifers:
    dic = RangedDictionary()
    mod = -5
    for i in range(0, 50, 2):
        dic[range(i, i + 1 + 1)] = mod
        mod += 1

    @classmethod
    def get(cls, value):
        return cls.dic[value]

from pprint import pprint
a = AttributeModifers()
pprint(a.dic, indent=4)
