# Copyright 2019,2020,2021 Sony Corporation.
# Copyright 2021 Sony Group Corporation.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


import nnabla.functions as F

from .utils import no_grad
from .._dropout_workaround import _get_dropout_mask


def dropout_backward(inputs, p=0.5, seed=-1):
    """
    Args:
      inputs (list of nn.Variable): Incomming grads/inputs to/of the forward function.
      kwargs (dict of arguments): Dictionary of the corresponding function arguments.

    Return:
      list of Variable: Return the gradients wrt inputs of the corresponding function.
    """
    # y = Dropout(x)
    # dy: the back-propagated gradient of y
    # xy: the back-propagated gradient of x
    dy = inputs[0]
    x = inputs[1]

    # Get mask to reproduce the random results of forward computation.
    # This variable is always prepared for dropout_backward because
    # GradEndFunction guarantees the computation order from dropout to
    # dropout_backward.
    mask = _get_dropout_mask(x)
    mask = no_grad(mask)
    # Protect mask before Dropout::backward uses and clear it.
    mask.persistent = True

    dx = dy * mask / (1 - p)
    return dx
