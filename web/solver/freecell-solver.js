// Copyright 2014 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Adapted from http://fc-solve.shlomifish.org/js-fc-solve/text/ by Shlomi Fish (Email: shlomif@shlomifish.org)
// At the time of the adaptation, the above web site stated:
//
//   "The markup and code of this site are, unless noted otherwise, licensed under the MIT/X11 license."
//

"use strict";

window.freecell = window.freecell || {};

(function(exports) {
    var freecell_solver_user_alloc = Module.cwrap('freecell_solver_user_alloc', 'number', []);
    var freecell_solver_user_solve_board = Module.cwrap('freecell_solver_user_solve_board', 'number', ['number', 'string']);
    var freecell_solver_user_resume_solution = Module.cwrap('freecell_solver_user_resume_solution', 'number', ['number']);
    var freecell_solver_user_cmd_line_read_cmd_line_preset = Module.cwrap('freecell_solver_user_cmd_line_read_cmd_line_preset', 'number', ['number', 'string', 'number', 'number', 'number', 'string']);
    var malloc = Module.cwrap('malloc', 'number', ['number']);
    var free = Module.cwrap('free', 'number', ['number']);
    var freecell_solver_user_get_next_move = Module.cwrap('freecell_solver_user_get_next_move', 'number', ['number', 'number']);
    var freecell_solver_user_current_state_as_string = Module.cwrap('freecell_solver_user_current_state_as_string', 'number', ['number', 'number', 'number', 'number']);
    var freecell_solver_user_move_ptr_to_string_w_state = Module.cwrap('freecell_solver_user_move_ptr_to_string_w_state', 'number', ['number', 'number', 'number']);
    var freecell_solver_user_free = Module.cwrap('freecell_solver_user_free', 'number', ['number']);
    var freecell_solver_user_limit_iterations = Module.cwrap('freecell_solver_user_limit_iterations', 'number', ['number', 'number']);
    var freecell_solver_user_get_invalid_state_error_string = Module.cwrap('freecell_solver_user_get_invalid_state_error_string', 'number', ['number', 'number']);

    var FCS_STATE_WAS_SOLVED = 0;
    var FCS_STATE_IS_NOT_SOLVEABLE = 1;
    var FCS_STATE_ALREADY_EXISTS = 2;
    var FCS_STATE_EXCEEDS_MAX_NUM_TIMES = 3;
    var FCS_STATE_BEGIN_SUSPEND_PROCESS = 4;
    var FCS_STATE_SUSPEND_PROCESS = 5;
    var FCS_STATE_EXCEEDS_MAX_DEPTH = 6;
    var FCS_STATE_ORIGINAL_STATE_IS_NOT_SOLVEABLE = 7;
    var FCS_STATE_INVALID_STATE = 8;
    var FCS_STATE_NOT_BEGAN_YET = 9;
    var FCS_STATE_DOES_NOT_EXIST = 10;
    var FCS_STATE_OPTIMIZED = 11;
    var FCS_STATE_FLARES_PLAN_ERROR = 12;

    var kCommandLinePreset = 'as';

    var kMaxIterations = 128 * 1024;
    var kIterationsStep = 1000;

    function stringifyAndFreePtr(ptr) {
        if (!ptr)
            return '';
        var string = Module.Pointer_stringify(ptr);
        free(ptr);
        return string;
    }

    function solve(board) {
        return new Promise(function(resolve, reject) {
            var currentIterationLimit = kIterationsStep;

            var solver = freecell_solver_user_alloc();
            if (solver == 0)
                return reject("Could not allocate solver instance (out of memory?)");

            start();

            function start() {
                var errorStringPtrBuffer = malloc(128);
                if (errorStringPtrBuffer == 0)
                    return reject("Failed to allocate (out of memory?).");

                var presetResult = freecell_solver_user_cmd_line_read_cmd_line_preset(solver, kCommandLinePreset, 0, errorStringPtrBuffer, 0, null);

                var errorString = stringifyAndFreePtr(getValue(errorStringPtrBuffer, '*'));

                free(errorStringPtrBuffer);

                if (presetResult != 0)
                    return reject("Failed to load command line preset '" + kCommandLinePreset + "'. Problem is: «" + errorString + "». Should not happen.");

                freecell_solver_user_limit_iterations(solver, currentIterationLimit);
                handleErrorCode(freecell_solver_user_solve_board(solver, board));
            }

            function handleErrorCode(errorCode) {
                if (errorCode == FCS_STATE_INVALID_STATE)
                    return reject(stringifyAndFreePtr(freecell_solver_user_get_invalid_state_error_string(solver, 1)));

                if (errorCode == FCS_STATE_SUSPEND_PROCESS) {
                    if (currentIterationLimit >= kMaxIterations)
                        return reject("Iterations count exceeded at " + currentIterationLimit);
                    setTimeout(resume, 0);
                    return;
                }

                if (errorCode == FCS_STATE_WAS_SOLVED) {
                    // 128 bytes are enough to hold a move.
                    var moveBuffer = malloc(128);

                    if (moveBuffer == 0)
                        reject("Failed to allocate a buffer for the move (out of memory?)");

                    var solution = [];

                    while (freecell_solver_user_get_next_move(solver, moveBuffer) == 0) {
                        var moveStringPtr = freecell_solver_user_move_ptr_to_string_w_state(solver, moveBuffer, 0);
                        if (moveStringPtr == 0)
                            reject("Failed to retrieve the current move as string (out of memory?)");
                        solution.push(stringifyAndFreePtr(moveStringPtr));
                    }

                    free(moveBuffer);
                    freecell_solver_user_free(solver);
                    solver = 0;

                    return resolve(solution.join('\n'));
                }

                if (errorCode == FCS_STATE_IS_NOT_SOLVEABLE)
                    return reject("Impossible!");

                return reject("Unknown Error code " + errorCode + "!");
            }

            function resume() {
                currentIterationLimit += kIterationsStep;
                freecell_solver_user_limit_iterations(solver, currentIterationLimit);
                handleErrorCode(freecell_solver_user_resume_solution(solver));
            }
        });
    }

    exports.solve = solve;
})(window.freecell);
