<template>
  <div class="bg-white rounded-lg shadow">
    <div class="px-4 py-5 sm:p-6">
      <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">
        Simulator
      </h3>
      
      <!-- Simulator Selection -->
      <div class="mb-6">
        <USelectMenu
          v-model="selectedSimulator"
          :options="simulators"
          option-attribute="name"
          placeholder="Select a simulator"
          class="w-full"
        >
          <template #label>
            <span v-if="selectedSimulator">
              {{ selectedSimulator.name }}
            </span>
            <span v-else>Select a simulator</span>
          </template>
          
          <template #option="{ option }">
            <div class="flex items-center justify-between w-full">
              <div>
                <p class="font-medium">{{ option.name }}</p>
                <p class="text-xs text-gray-500">{{ option.runtime }}</p>
              </div>
              <UBadge 
                :color="option.state === 'Booted' ? 'green' : 'gray'"
                size="xs"
              >
                {{ option.state }}
              </UBadge>
            </div>
          </template>
        </USelectMenu>
      </div>

      <!-- Simulator Info -->
      <div v-if="selectedSimulator" class="space-y-3 mb-6">
        <div class="flex justify-between text-sm">
          <span class="text-gray-500">Device Type:</span>
          <span class="font-medium">{{ selectedSimulator.deviceType }}</span>
        </div>
        <div class="flex justify-between text-sm">
          <span class="text-gray-500">Runtime:</span>
          <span class="font-medium">{{ selectedSimulator.runtime }}</span>
        </div>
        <div class="flex justify-between text-sm">
          <span class="text-gray-500">State:</span>
          <UBadge 
            :color="selectedSimulator.state === 'Booted' ? 'green' : 'gray'"
            size="xs"
          >
            {{ selectedSimulator.state }}
          </UBadge>
        </div>
      </div>

      <!-- Simulator Actions -->
      <div class="space-y-3">
        <UButton
          v-if="selectedSimulator && selectedSimulator.state !== 'Booted'"
          color="primary"
          block
          @click="bootSimulator"
          :loading="isBooting"
        >
          <UIcon name="i-heroicons-power" class="mr-2" />
          Boot Simulator
        </UButton>
        
        <UButton
          v-if="selectedSimulator && selectedSimulator.state === 'Booted'"
          color="red"
          variant="soft"
          block
          @click="shutdownSimulator"
          :loading="isShuttingDown"
        >
          <UIcon name="i-heroicons-power" class="mr-2" />
          Shutdown Simulator
        </UButton>

        <UButton
          v-if="selectedSimulator && selectedSimulator.state === 'Booted' && hasApp"
          color="primary"
          variant="soft"
          block
          @click="installApp"
          :loading="isInstalling"
        >
          <UIcon name="i-heroicons-arrow-down-tray" class="mr-2" />
          Install App
        </UButton>

        <UButton
          v-if="selectedSimulator && selectedSimulator.state === 'Booted' && hasApp"
          color="primary"
          variant="soft"
          block
          @click="launchApp"
          :loading="isLaunching"
        >
          <UIcon name="i-heroicons-rocket-launch" class="mr-2" />
          Launch App
        </UButton>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SimulatorControls',
  props: {
    simulators: {
      type: Array,
      default: () => []
    },
    hasApp: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      selectedSimulator: null,
      isBooting: false,
      isShuttingDown: false,
      isInstalling: false,
      isLaunching: false
    }
  },
  methods: {
    async bootSimulator() {
      this.isBooting = true
      this.$emit('boot-simulator', this.selectedSimulator)
      // Simulating async operation
      setTimeout(() => {
        this.isBooting = false
        this.selectedSimulator.state = 'Booted'
      }, 2000)
    },
    
    async shutdownSimulator() {
      this.isShuttingDown = true
      this.$emit('shutdown-simulator', this.selectedSimulator)
      setTimeout(() => {
        this.isShuttingDown = false
        this.selectedSimulator.state = 'Shutdown'
      }, 1000)
    },
    
    async installApp() {
      this.isInstalling = true
      this.$emit('install-app', this.selectedSimulator)
      setTimeout(() => {
        this.isInstalling = false
      }, 1500)
    },
    
    async launchApp() {
      this.isLaunching = true
      this.$emit('launch-app', this.selectedSimulator)
      setTimeout(() => {
        this.isLaunching = false
      }, 1000)
    }
  }
}
</script>