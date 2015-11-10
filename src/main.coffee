matching = require('./matching')
scoring = require('./scoring')
time_estimates = require('./time_estimates')

time = -> (new Date()).getTime()

append_frequency_lists = (new_frequency_lists) ->
  matching.append_frequency_lists(new_frequency_lists)

zxcvbn = (password, user_inputs = []) ->
  start = time()
  # reset the user inputs matcher on a per-request basis to keep things stateless
  sanitized_inputs = []
  for arg in user_inputs
    if typeof arg in ["string", "number", "boolean"]
      sanitized_inputs.push arg.toString().toLowerCase()
  matching.set_user_input_dictionary sanitized_inputs
  matches = matching.omnimatch password
  result = scoring.most_guessable_match_sequence password, matches
  result.calc_time = time() - start
  attack_times = time_estimates.estimate_attack_times result.guesses
  for prop, val of attack_times
    result[prop] = val
  result

module.exports = {
  score: zxcvbn,
  append_frequency_lists: append_frequency_lists
}
