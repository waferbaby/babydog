import svelte from 'rollup-plugin-svelte'
import commonjs from '@rollup/plugin-commonjs'
import resolve from '@rollup/plugin-node-resolve'
import json from '@rollup/plugin-json'
import livereload from 'rollup-plugin-livereload'
import { terser } from 'rollup-plugin-terser'

const production = !process.env.ROLLUP_WATCH

function serve () {
  let server

  function toExit () {
    if (server) server.kill(0)
  }

  return {
    writeBundle () {
      if (server) return
      server = require('child_process').spawn('npm', ['run', 'start', '--', '--dev'], {
        stdio: ['ignore', 'inherit', 'inherit'],
        shell: true
      })

      process.on('SIGTERM', toExit)
      process.on('exit', toExit)
    }
  }
}

export default {
  input: 'src/main.js',
  output: {
    sourcemap: false,
    format: 'iife',
    name: 'app',
    file: 'public/js/bundle.js'
  },
  plugins: [
    svelte({
      compilerOptions: {
        dev: !production
      }
    }),
    resolve({
      browser: true,
      dedupe: ['svelte']
    }),
    json(),
    commonjs(),
    !production && serve(),
    !production && livereload('public'),
    production && terser()
  ],
  watch: {
    clearScreen: false
  }
}
