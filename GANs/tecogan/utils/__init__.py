from __future__ import absolute_import
import os
import sys
common_utils_path = os.path.abspath(
    os.path.join(os.path.dirname(__file__), '..', '..', '..', 'utils'))
print(common_utils_path)
sys.path.append(common_utils_path)
from neu.yaml_wrapper import read_yaml
from neu.misc import AttrDict
