<script>
  import words from './data/words.js'
  import { capitalise, getRandomEntry } from './utils.js'

  let strike_name = ''
  let strike_details = ''

  function generateStrikeName() {
    strike_name = capitalise(getRandomEntry(words)) + capitalise(getRandomEntry(words))
  }

  function generateStrikeDetails() {
    strike_details = "..."
  }

  generateStrikeName()
  generateStrikeDetails()

</script>

<section>
  <h1 on:click={generateStrikeName}>Operation... {strike_name}?</h1>
  <p on:click={generateStrikeDetails}>{strike_details}</p>
</section>
