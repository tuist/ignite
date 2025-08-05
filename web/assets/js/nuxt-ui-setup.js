import { defineNuxtPlugin } from '@nuxt/ui/dist/runtime/plugins/colors'
import UButton from '@nuxt/ui/dist/runtime/components/UButton.vue'
import UIcon from '@nuxt/ui/dist/runtime/components/UIcon.vue'
import USelectMenu from '@nuxt/ui/dist/runtime/components/USelectMenu.vue'
import URadioGroup from '@nuxt/ui/dist/runtime/components/URadioGroup.vue'
import UCheckbox from '@nuxt/ui/dist/runtime/components/UCheckbox.vue'
import UBadge from '@nuxt/ui/dist/runtime/components/UBadge.vue'
import UInput from '@nuxt/ui/dist/runtime/components/forms/Input.vue'
import UApp from '@nuxt/ui/dist/runtime/components/layout/App.vue'
import { theme, nuxtUIConfig } from './theme'

export function setupNuxtUI(app) {
  // Register components globally
  app.component('UButton', UButton)
  app.component('UIcon', UIcon)
  app.component('USelectMenu', USelectMenu)
  app.component('URadioGroup', URadioGroup)
  app.component('UCheckbox', UCheckbox)
  app.component('UBadge', UBadge)
  app.component('UInput', UInput)
  app.component('UApp', UApp)
  
  // Set up color mode
  app.config.globalProperties.$colorMode = {
    preference: 'light',
    value: 'light'
  }
  
  // Apply purple theme configuration
  app.config.globalProperties.$ui = nuxtUIConfig.ui
}