<script>
  import nouns from '../corpora/data/words/nouns.json'
  import verbs from '../corpora/data/words/verbs.json'

  import { capitalise, getRandomEntry } from './utils.js'

  let strike_name = ''
  let strike_details = ''

  function generateStrike() {
    generateStrikeName()
    generateStrikeDetails()
  }

  function generateStrikeName() {
    strike_name = capitalise(getRandomEntry(nouns['nouns'])) + ' ' + capitalise(getRandomEntry(verbs['verbs'])['present'])
  }

  function generateStrikeDetails() {
    strike_details = "..."
  }

  generateStrike();
</script>

  <h1>Operation...</h1>
  <strong>{strike_name}?</strong>
  <p>{strike_details}</p>

  <button on:click={generateStrike}>Reboot Strike Generator</button>
