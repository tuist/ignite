<template>
  <div class="bg-white rounded-lg shadow">
    <div class="px-4 py-5 sm:p-6">
      <h3 class="text-lg leading-6 font-medium text-gray-900">
        Build Configuration
      </h3>
      
      <div class="mt-6 space-y-4">
        <!-- Project Selection -->
        <div>
          <USelectMenu
            v-model="selectedProject"
            :options="projects"
            option-attribute="name"
            placeholder="Select a project"
            class="w-full"
          >
            <template #label>
              <span v-if="selectedProject">{{ selectedProject.name }}</span>
              <span v-else>Select a project</span>
            </template>
          </USelectMenu>
        </div>

        <!-- Build Type -->
        <div>
          <URadioGroup
            v-model="buildType"
            :options="buildTypes"
            class="space-y-2"
          />
        </div>

        <!-- Platform Selection -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Platform
          </label>
          <div class="flex space-x-2">
            <UCheckbox
              v-for="platform in platforms"
              :key="platform.value"
              v-model="selectedPlatforms"
              :value="platform.value"
              :label="platform.label"
            />
          </div>
        </div>

        <!-- Build Actions -->
        <div class="flex space-x-3 pt-4">
          <UButton
            color="primary"
            @click="startBuild"
            :loading="isBuilding"
            :disabled="!canBuild"
          >
            <UIcon name="i-heroicons-play" class="mr-2" />
            Build
          </UButton>
          
          <UButton
            color="red"
            variant="soft"
            @click="stopBuild"
            :disabled="!isBuilding"
          >
            <UIcon name="i-heroicons-stop" class="mr-2" />
            Stop
          </UButton>
        </div>
      </div>

      <!-- Build Output -->
      <div v-if="buildOutput.length > 0" class="mt-6">
        <h4 class="text-sm font-medium text-gray-700 mb-2">Build Output</h4>
        <div class="bg-gray-900 text-gray-100 rounded-md p-4 font-mono text-sm overflow-x-auto max-h-96 overflow-y-auto">
          <div v-for="(line, index) in buildOutput" :key="index">
            {{ line }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'BuildInterface',
  props: {
    projects: {
      type: Array,
      default: () => []
    }
  },
  data() {
    return {
      selectedProject: null,
      buildType: 'debug',
      buildTypes: [
        { value: 'debug', label: 'Debug' },
        { value: 'release', label: 'Release' }
      ],
      platforms: [
        { value: 'ios', label: 'iOS' },
        { value: 'macos', label: 'macOS' },
        { value: 'tvos', label: 'tvOS' },
        { value: 'watchos', label: 'watchOS' }
      ],
      selectedPlatforms: ['ios'],
      isBuilding: false,
      buildOutput: []
    }
  },
  computed: {
    canBuild() {
      return this.selectedProject && this.selectedPlatforms.length > 0 && !this.isBuilding
    }
  },
  methods: {
    startBuild() {
      this.$emit('start-build', {
        project: this.selectedProject,
        buildType: this.buildType,
        platforms: this.selectedPlatforms
      })
      this.isBuilding = true
      this.buildOutput = ['Starting build...']
    },
    
    stopBuild() {
      this.$emit('stop-build')
      this.isBuilding = false
      this.buildOutput.push('Build cancelled.')
    },
    
    addBuildOutput(line) {
      this.buildOutput.push(line)
    }
  }
}
</script>