# Copyright 2019,2020,2021 Sony Corporation.
# Copyright 2022 Sony Group Corporation.
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

import pytest
import nnabla.solvers as S
import numpy as np
from solver_test_utils import solver_tester, RefSolver, MixinWeightDecayFused
from nbla_test_utils import list_context

ctxs = list_context('Lars')


class RefLars(MixinWeightDecayFused, RefSolver):

    def __init__(self, lr, momentum, coefficient, eps):
        super().__init__()
        self.lr = lr
        self.momentum = momentum
        self.coefficient = coefficient
        self.eps = eps
        self.v = {}

    def _set_state_impl(self, key, param):
        self.v[key] = np.zeros_like(param)

    def _update_impl(self, key, p, g):
        d_norm = np.linalg.norm(p)
        g_norm = np.linalg.norm(g)
        g = g + self.weight_decay_rate * p
        if d_norm < self.eps:
            lr = self.lr
        else:
            lr = self.lr * self.coefficient * d_norm / \
                (g_norm + self.weight_decay_rate * d_norm)
        _update_lars(p, g, self.v[key], lr, self.momentum)


def _update_lars(p, g, v, lr, momentum):
    v[...] = v * momentum + lr * g
    p[...] = p - v


@pytest.mark.parametrize("ctx, solver_name", ctxs)
@pytest.mark.parametrize("decay", [1e-4])
@pytest.mark.parametrize("lr", [1e-1, 1e-3])
@pytest.mark.parametrize("momentum", [0.9, 0.5])
@pytest.mark.parametrize("coefficient", [0.001])
@pytest.mark.parametrize("eps", [1e-8])
@pytest.mark.parametrize("seed", [313])
def test_lars(seed, lr, momentum, coefficient, decay, eps, ctx, solver_name):
    rng = np.random.RandomState(seed)
    solver_tester(
        rng, S.Lars, RefLars, [lr, momentum, coefficient, eps],
        atol=1e-6, decay=decay, ctx=ctx, solver_name=solver_name)
